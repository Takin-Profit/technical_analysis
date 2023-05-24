/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'dart:math';
import 'dart:typed_data';

import 'circular_buffer.dart';
import 'quotes.dart';
import 'series.dart';
import 'types.dart';
import 'util.dart';

double _rsi(List<double> data) {
  int lookBack = 3;

  Float64List gain = Float64List(lookBack);
  Float64List loss = Float64List(lookBack);

  for (int i = 1; i < lookBack; i++) {
    double change = data[i] - data[i - 1];
    gain[i] = max(0, change);
    loss[i] = max(0, -change);
  }

  double avgGain = gain.reduce((a, b) => a + b) / lookBack;
  double avgLoss = loss.reduce((a, b) => a + b) / lookBack;

  double rs = avgGain / avgLoss;

  return 100 - (100 / (rs + 1));
}

double _willy(List<double> data) {
  var high = data.reduce(max);
  var low = data.reduce(min);

  return 60 * (data.last - high) / (high - low) + 80;
}

double _mfi(List<({double val, double vol})> data) {
  int lookBack = 3;

  Float64List upper = Float64List(lookBack);
  Float64List lower = Float64List(lookBack);

  for (int i = 1; i < lookBack; i++) {
    double change = data[i].val - data[i - 1].val;
    double mf = data[i].vol * data[i].val; // Raw Money Flow

    if (change > 0) {
      upper[i] = mf;
      lower[i] = 0.0;
    } else if (change < 0) {
      upper[i] = 0.0;
      lower[i] = mf;
    }
  }

  double upperSum = upper.reduce((a, b) => a + b);
  double lowerSum = lower.reduce((a, b) => a + b);

  double mfi;
  if (lowerSum != 0) {
    double mfRatio = upperSum / lowerSum;
    mfi = 100 - (100 / (mfRatio + 1));
  } else {
    mfi = 100;
  }

  return mfi;
}

double _tci(List<double> data) {
  int length = 9;
  double emaSrc = double.nan;
  double emaDiffAbs = double.nan;
  double emaTCIRaw = double.nan;
  final double multiplierSrc = 2 / (length + 1);
  final double multiplierDiffAbs = 2 / (length + 1);
  final double multiplierTCIRaw = 2 / (length + 1);

  for (int i = 0; i < length; i++) {
    final currentData = data[i];

    if (emaSrc.isNaN) {
      emaSrc = data.take(length).reduce((prev, next) => prev + next) / length;
      emaDiffAbs = data
              .take(length)
              .map((el) => (el - emaSrc).abs())
              .reduce((prev, next) => prev + next) /
          length;
      emaTCIRaw = data
              .take(length)
              .map((el) => (el - emaSrc) / (0.025 * (el - emaSrc).abs()))
              .reduce((prev, next) => prev + next) /
          length;
    } else {
      emaSrc = (currentData - emaSrc) * multiplierSrc + emaSrc;
      final diffAbs = (currentData - emaSrc).abs();
      emaDiffAbs = (diffAbs - emaDiffAbs) * multiplierDiffAbs + emaDiffAbs;
      final tciRaw = (currentData - emaSrc) / (emaDiffAbs * 0.025);
      emaTCIRaw = (tciRaw - emaTCIRaw) * multiplierTCIRaw + emaTCIRaw;
    }
  }

  return emaTCIRaw + 50;
}

double _ema(List<double> data, int length) {
  // Calculation of Exponential Moving Average (EMA)
  double ema = 0;
  double multiplier = 2 / (length + 1);

  for (int i = 0; i < data.length; i++) {
    ema = i == 0 ? data[i] : (data[i] - ema) * multiplier + ema;
  }

  return ema;
}

double _tsi(List<double> data) {
  List<double> momentum =
      List.generate(data.length - 1, (index) => data[index + 1] - data[index]);
  momentum.insert(0, 0); // First momentum is assumed to be zero

  List<double> emaMomentum =
      List.generate(momentum.length, (index) => _ema(momentum, 9));
  List<double> emaAbsMomentum = List.generate(
    momentum.length,
    (index) => _ema(momentum.map((e) => e.abs()).toList(), 9),
  );

  double numerator = _ema(emaMomentum, 6);
  double denominator = _ema(emaAbsMomentum, 6);

  return numerator * 100 / denominator;
}

double _csi({required double rsi, required List<double> tsiBuf}) {
  return ((rsi + _tsi(tsiBuf)) * 50 + 50) / 2;
}

double _linReg(List<double> data) {
  List<double> x = List.generate(
    data.length,
    (index) => index.toDouble(),
  );

  SimpleLinearRegression lr = SimpleLinearRegression(x, data);

  return lr.predict((data.length - 1).toDouble());
}

typedef PhxResult = ({DateTime date, double fast, double slow, double lsma});

Stream<PhxResult> calcPhx(Series<Quote> series) async* {
  // tci needs hlc3 data len 9
  // willy needs hlc3 data len 6
  final hlc3Buffer = CircularBuffer<double>(9);
  // tsi need open data len 9
  final openBuffer = CircularBuffer<double>(9);
  // mfi needs hlc3 with vol len 6
  final hlc3WithVolBuffer = CircularBuffer<({double val, double vol})>(6);
  final linRegBuffer = CircularBuffer<double>(32);

  final allBuffersFull = () =>
      hlc3Buffer.isFilled && openBuffer.isFilled && hlc3WithVolBuffer.isFilled;

  await for (final quote in series) {
    final hlc3 = quote.toPriceDataDouble(candlePart: CandlePart.hlc3);
    final open = quote.toPriceDataDouble(candlePart: CandlePart.open);
    final hlc3WithVol =
        quote.toPriceDataDoubleWithVol(candlePart: CandlePart.hlc3);

    hlc3Buffer.add(hlc3.value);
    // tsi needs open price data, first in the zipped stream
    openBuffer.add(open.value);
    // mfi needs hlc3 and volume data, last in the zipped stream
    hlc3WithVolBuffer.add((val: hlc3WithVol.value, vol: hlc3WithVol.vol));

    if (allBuffersFull()) {
      final tci = _tci(hlc3Buffer);
      final mfi = _mfi(hlc3WithVolBuffer);
      final willy = _willy(hlc3Buffer.skip(3).toList());
      final rsi = _rsi(hlc3Buffer.skip(6).toList());
      final csi = _csi(rsi: rsi, tsiBuf: openBuffer);
      final phx = (tci + csi + mfi + willy) / 4;
      final trad = (tci + mfi + rsi) / 3;
      linRegBuffer.add(phx);
      if (linRegBuffer.isFilled) {
        yield (
          date: quote.date,
          fast: phx,
          slow: trad,
          lsma: _linReg(linRegBuffer)
        );
      } else {
        yield (date: quote.date, fast: phx, slow: trad, lsma: double.nan);
      }
    } else {
      yield (
        date: quote.date,
        fast: double.nan,
        slow: double.nan,
        lsma: double.nan
      );
    }
  }
}
