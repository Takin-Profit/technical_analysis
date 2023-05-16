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
  Series<PriceDataDouble> series, {
  int lookBack = 14,
}) async* {
  final highestBuffer = CircularBuffer<PriceDataDouble>(lookBack);
  final lowestBuffer = CircularBuffer<PriceDataDouble>(lookBack);

  await for (final current in series) {
    highestBuffer.add(current);
    lowestBuffer.add(current);

    if (highestBuffer.isFilled && lowestBuffer.isFilled) {
      final maxHigh = highestBuffer.map((e) => e.value).reduce(max);
      final minLow = lowestBuffer.map((e) => e.value).reduce(min);
      final currentClose = current.value;

      final percentR = 100 * (currentClose - maxHigh) / (maxHigh - minLow);

      yield (date: current.date, value: percentR);
    } else {
      yield (date: current.date, value: double.nan);
    }
  }
}
