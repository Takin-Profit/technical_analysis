/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'dart:math';

import 'circular_buffer.dart';
import 'series.dart';
import 'types.dart';

Series<PriceDataDouble> calcWPR(
  QuoteSeries series, {
  int lookBack = 14,
}) async* {
  final highestBuffer = CircularBuffer<double>(lookBack);
  final lowestBuffer = CircularBuffer<double>(lookBack);

  await for (final current in series) {
    highestBuffer.add(current.high.toDouble());
    lowestBuffer.add(current.low.toDouble());

    if (highestBuffer.isFilled && lowestBuffer.isFilled) {
      final highest = highestBuffer.reduce(max);
      final lowest = lowestBuffer.reduce(min);

      final percentR =
          -100 * (highest - current.close.toDouble()) / (highest - lowest);

      yield (date: current.date, value: percentR);
    } else {
      yield (date: current.date, value: double.nan);
    }
  }
}
