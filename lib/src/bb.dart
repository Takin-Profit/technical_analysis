/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'dart:math';

import 'package:collection/collection.dart';
import 'package:technical_analysis/src/list_ext.dart';

import 'circular_buf.dart';
import 'series.dart';
import 'types.dart';

typedef BBResult = ({DateTime date, double upper, double lower, double middle});

Series<BBResult> calcBB(
  Series<PriceData> series, {
  int lookBack = 20,
  double multi = 2.0,
}) async* {
  final smaBuf = circularBuf(size: lookBack);
  final stdDevBuf = circularBuf(size: lookBack);

  await for (final data in series) {
    smaBuf.put(data.value);
    stdDevBuf.put(data.value);

    if (smaBuf.isFilled) {
      // Calculate SMA for the middle band
      final sma = smaBuf.sma;

      // Calculate standard deviation for the deviation
      final mean = stdDevBuf.average;

      final variance = stdDevBuf.map((el) => pow(el - mean, 2)).average;

      final stdDev = sqrt(variance);

      // Calculate the upper and lower bands
      final upper = sma + multi * stdDev;
      final lower = sma - multi * stdDev;

      yield (
        date: data.date,
        upper: upper,
        lower: lower,
        middle: sma,
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
