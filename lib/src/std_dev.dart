/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'dart:math';

import 'circular_buf.dart';
import 'list_ext.dart';
import 'series.dart';
import 'types.dart';

Series<PriceData> calcStdDev(
  Series<PriceData> series, {
  int length = 1,
  StDev bias = StDev.population,
}) async* {
  final buffer = circularBuf(size: length);
  // adjusts the divisor accordingly
  int divisor() {
    return bias == StDev.population
        ? length
        : length - 1 > 0
            ? length - 1
            : 1;
  }

  await for (final data in series) {
    buffer.put(data.value);

    if (buffer.isFilled) {
      final mean = buffer.sma;

      final variance = buffer
              .map((el) => pow(el - mean, 2))
              .reduce((prev, next) => prev + next) /
          divisor(); // use adjusted divisor for variance calculation
      final stdDev = sqrt(variance);
      yield (date: data.date, value: stdDev);
    } else {
      yield (date: data.date, value: double.nan);
    }
  }
}
