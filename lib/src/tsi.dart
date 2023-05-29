// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'ema.dart';
import 'series.dart';
import 'types.dart';

typedef TsiResult = ({DateTime date, double value, double? signal});

/// requires a warmup period of at least 200 bars for best accuracy.
Series<TsiResult> calcTSI(
  Series<PriceData> series, {
  int len = 25,
  int smoothLen = 13,
  int signalLen = 13,
}) async* {
  final tsi = getTSI(len: len, smoothLen: smoothLen, signalLen: signalLen);
  await for (final data in series) {
    final result = tsi(data.value);
    yield (date: data.date, value: result.value, signal: result.signal);
  }
}

double Function(double) doubleSmooth({
  required int long,
  required int short,
}) {
  final emaShort = getEma(len: short);
  final emaLong = getEma(len: long);

  return (double value) => emaShort(emaLong(value));
}

({double value, double? signal}) Function(double) getTSI({
  int len = 25,
  int smoothLen = 13,
  int signalLen = 13,
}) {
  double? lastValue;
  final doubleSmoothPC = doubleSmooth(long: len, short: smoothLen);
  final doubleSmoothAPC = doubleSmooth(long: len, short: smoothLen);
  final emaSignal = getEma(len: signalLen);

  return (double value) {
    double pc = 0;
    double apc = 0;

    if (lastValue != null) {
      pc = value - lastValue!;
      apc = pc.abs();
    }

    lastValue = value;

    double doubleSmoothPCValue = doubleSmoothPC(pc);
    double doubleSmoothAPCValue = doubleSmoothAPC(apc);

    if (doubleSmoothPCValue.isNaN || doubleSmoothAPCValue.isNaN) {
      return (value: double.nan, signal: double.nan);
    }

    double tsi = doubleSmoothAPCValue != 0
        ? doubleSmoothPCValue * 100 / doubleSmoothAPCValue
        : 0;
    double signal = emaSignal(tsi);

    return (value: tsi, signal: signal.isNaN ? double.nan : signal);
  };
}
