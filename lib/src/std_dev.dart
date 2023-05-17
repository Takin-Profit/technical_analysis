/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'dart:math';

import 'circular_buffer.dart';
import 'series.dart';
import 'types.dart';

Series<PriceDataDouble> calcStdDev(
  Series<PriceDataDouble> series, {
  int length = 1,
}) async* {
  final buffer = CircularBuffer<PriceDataDouble>(length);

  await for (final data in series) {
    buffer.add(data);

    if (buffer.isFilled) {
      final mean =
          buffer.map((el) => el.value).reduce((prev, next) => prev + next) /
              length;
      final variance = buffer
              .map((el) => pow(el.value - mean, 2))
              .reduce((prev, next) => prev + next) /
          length;
      final stdDev = sqrt(variance);
      yield (date: data.date, value: stdDev);
    } else {
      yield (date: data.date, value: double.nan);
    }
  }
}
