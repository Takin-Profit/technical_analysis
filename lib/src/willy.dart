/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import "dart:math";

import 'circular_buffer.dart';
import 'types.dart';

Stream<PriceDataDouble> calcWilly(Stream<PriceDataDouble> series) async* {
  final buffer = CircularBuffer<PriceDataDouble>(6);

  await for (final data in series) {
    buffer.add(data);

    if (buffer.isFilled) {
      final high = buffer.map((el) => el.value).reduce(max);
      final low = buffer.map((el) => el.value).reduce(min);
      final willy = 60 * (data.value - high) / (high - low) + 80;

      yield (date: data.date, value: willy);
    } else {
      yield (date: data.date, value: double.nan);
    }
  }
}
