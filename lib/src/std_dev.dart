/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'dart:math';

import 'circular_buffer.dart';
import 'series.dart';
import 'sma.dart';
import 'types.dart';

Series<PriceDataDouble> stdDev(
  Series<PriceDataDouble> series, {
  int length = 1,
}) async* {
  final smaStream = calcSMA(series, lookBack: length);
  final buffer = CircularBuffer<PriceDataDouble>(length);

  await for (final data in smaStream) {
    buffer.add(data);

    if (buffer.isFilled) {
      final sma = data.value;
      final variance = buffer
              .map((el) => pow(el.value - sma, 2))
              .reduce((prev, next) => prev + next) /
          length;
      yield (date: data.date, value: sqrt(variance));
    } else {
      yield (date: data.date, value: double.nan);
    }
  }
}
