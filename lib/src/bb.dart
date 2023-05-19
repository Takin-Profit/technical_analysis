/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'dart:math';

import 'circular_buffer.dart';
import 'series.dart';
import 'types.dart';

typedef BBResult = ({DateTime date, double upper, double lower, double middle});

Series<BBResult> calcBB(
  Series<PriceDataDouble> series, {
  int lookBack = 20,
  double multi = 2.0,
}) async* {
  final smaBuffer = CircularBuffer<PriceDataDouble>(lookBack);
  final stdDevBuffer = CircularBuffer<PriceDataDouble>(lookBack);

  await for (final data in series) {
    smaBuffer.add(data);
    stdDevBuffer.add(data);

    if (smaBuffer.isFilled) {
      // Calculate SMA for the middle band
      final sma =
          smaBuffer.map((el) => el.value).reduce((prev, next) => prev + next) /
              lookBack;

      // Calculate standard deviation for the deviation
      final mean = stdDevBuffer
              .map((el) => el.value)
              .reduce((prev, next) => prev + next) /
          lookBack;
      final variance = stdDevBuffer
              .map((el) => pow(el.value - mean, 2))
              .reduce((prev, next) => prev + next) /
          lookBack;
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
