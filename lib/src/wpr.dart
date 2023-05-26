/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'dart:math';

import 'circular_buf.dart';
import 'series.dart';
import 'types.dart';

Series<PriceData> calcWPR(
  QuoteSeries series, {
  int lookBack = 14,
}) async* {
  final highestBuffer = circularBuf(size: lookBack);
  final lowestBuffer = circularBuf(size: lookBack);

  await for (final current in series) {
    highestBuffer.put(current.high.toDouble());
    lowestBuffer.put(current.low.toDouble());

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
