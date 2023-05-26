/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'dart:math';

import 'package:collection/collection.dart';

import 'circular_buf.dart';
import 'series.dart';
import 'types.dart';

typedef BBResult = ({DateTime date, double upper, double lower, double middle});

Series<BBResult> calcBB(
  Series<PriceData> series, {
  int lookBack = 20,
  double multi = 2.0,
}) async* {
  final smaBuf = CircularBuf(size: lookBack);
  final stdDevBuf = CircularBuf(size: lookBack);

  await for (final data in series) {
    smaBuf.put(data.value);
    stdDevBuf.put(data.value);

    if (smaBuf.isFull) {
      // Calculate SMA for the middle band
      final _sma = smaBuf.values.average;

      // Calculate standard deviation for the deviation
      final mean = stdDevBuf.values.average;

      final variance = stdDevBuf.values.map((el) => pow(el - mean, 2)).average;

      final stdDev = sqrt(variance);

      // Calculate the upper and lower bands
      final upper = _sma + multi * stdDev;
      final lower = _sma - multi * stdDev;

      yield (
        date: data.date,
        upper: upper,
        lower: lower,
        middle: _sma,
      );
    } else {
      yield (
        date: data.date,
        upper: double.nan,
        lower: double.nan,
        middle: double.nan,
      );
    }
  }
}
