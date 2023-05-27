/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';

import 'circular_buf.dart';
import 'linreg.dart';
import 'mfi.dart';
import 'rsi.dart';
import 'series.dart';
import 'sma.dart';
import 'tci.dart';
import 'tsi.dart';
import 'util.dart';
import 'willy.dart';

double _linReg(Iterable<double> data) {
  List<double> x = List.generate(
    32,
    (index) => index.toDouble(),
  );

  SimpleLinearRegression lr = SimpleLinearRegression(x, data);

  return lr.predict((data.length - 1).toDouble());
}

typedef PhxResult = ({DateTime date, double fast, double slow, double lsma});

Stream<PhxResult> calcPhx(QuoteSeries series) async* {
  final hlc3 = series.hlc3.asBroadcastStream();
  final tciStream = calcTCI(hlc3);
  final mfiStream = calcMFI(series.hlc3WithVol, len: 3);
  final willyStream = calcWilly(hlc3);
  final rsiStream = calcRSI(hlc3, len: 3);
  final tsiStream = calcTSI(series.open, len: 9, smoothLen: 6)
      .map((el) => (date: el.date, value: el.value));

  final linRegBuf = CircularBuf(size: 32);
  final smaBuf = CircularBuf(size: 6);

  final zipStream = ZipStream.zip5(
    tciStream,
    mfiStream,
    willyStream,
    rsiStream,
    tsiStream,
    (a, b, c, d, e) => (
      date: b.date,
      tci: a.value,
      mfi: b.value,
      willy: c.value,
      rsi: d.value,
      tsi: e.value
    ),
  );

  await for (final data in zipStream) {
    final tci = data.tci;
    final mfi = data.mfi;
    final willy = data.willy;
    final rsi = data.rsi;
    final tsi = data.tsi / 100;

    final csi = [rsi, (tsi * 50 + 50)].average;
    final phx = [tci, csi, mfi, willy].average;
    final trad = [tci, mfi, rsi].average;
    final fast = [phx, trad].average;

    smaBuf.put(fast);
    linRegBuf.put(fast);

    final linReg =
        linRegBuf.isFull ? _linReg(linRegBuf.orderedValues) : double.nan;
    final slow = smaBuf.isFull ? smaBuf.values.average : double.nan;

    yield (date: data.date, fast: fast, slow: slow, lsma: linReg);
  }
}

PhxResult Function(
  ({
    DateTime date,
    double open,
    double high,
    double low,
    double close,
    double volume
  }),
) getPhx() {
  final getRsi = getRSI(len: 3);
  final getMfi = getMFI(len: 3);
  final getTsi = getTSI(len: 9, smoothLen: 6);
  final getSma = getSMA(len: 6);
  final getWilly = getWILLY(len: 6);
  final getTci = getTCI(len: 9);
  final getLinReg = getLINREG(len: 32);

  return (({
        DateTime date,
        double open,
        double high,
        double low,
        double close,
        double volume
      }) quote) {
    final hlc3 = (quote.high + quote.low + quote.close) / 3;
    final tci = getTci(hlc3);
    final mfi = getMfi(value: hlc3, vol: quote.volume);
    final willy = getWilly(hlc3);
    final rsi = getRsi(hlc3);
    final tsi = getTsi(hlc3).value / 100;

    final csi = (rsi + (tsi * 50 + 50)) / 2;
    final phx = (tci + csi + mfi + willy) / 4;
    final trad = (tci + mfi + rsi) / 3;
    final fast = (phx + trad) / 2;

    final slow = getSma(fast);
    final lsma = getLinReg(fast);

    return (date: quote.date, fast: fast, slow: slow, lsma: lsma);
  };
}
