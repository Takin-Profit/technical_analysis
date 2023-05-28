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

({double value, double? signal}) Function(double) getTSI({
  int len = 25,
  int smoothLen = 13,
  int signalLen = 13,
}) {
  double? lastValue;

  var firstEmaPC = getEma(len: len);
  var firstEmaAPC = getEma(len: len);
  var secondEmaPC = getEma(len: smoothLen);
  var secondEmaAPC = getEma(len: smoothLen);
  var emaSignal = getEma(len: signalLen);

  return (double value) {
    double pc = 0;
    double apc = 0;

    if (lastValue != null) {
      pc = value - lastValue!;
      apc = pc.abs();
    }

    lastValue = value;

    double firstEmaPCValue = (firstEmaPC(pc));
    double firstEmaAPCValue = firstEmaAPC(apc);

    if (firstEmaPCValue.isNaN || firstEmaAPCValue.isNaN) {
      return (value: double.nan, signal: double.nan);
    }

    double secondEmaPCValue = secondEmaPC(firstEmaPCValue);
    double secondEmaAPCValue = secondEmaAPC(firstEmaAPCValue);

    if (secondEmaPCValue.isNaN || secondEmaAPCValue.isNaN) {
      return (value: double.nan, signal: double.nan);
    }

    double tsi =
        secondEmaAPCValue != 0 ? secondEmaPCValue * 100 / secondEmaAPCValue : 0;
    double signal = emaSignal(tsi);

    return (value: tsi, signal: signal.isNaN ? double.nan : signal);
  };
}
