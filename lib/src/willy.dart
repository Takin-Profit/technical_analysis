/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import "dart:math";

import 'circular_buf.dart';
import 'types.dart';

Stream<PriceData> calcWilly(Stream<PriceData> series) async* {
  final buffer = CircularBuf(size: 6);

  await for (final data in series) {
    buffer.put(data.value);

    if (buffer.isFull) {
      final high = buffer.values.reduce(max);
      final low = buffer.values.reduce(min);
      final willy = 60 * (data.value - high) / (high - low) + 80;

      yield (date: data.date, value: willy);
    } else {
      yield (date: data.date, value: double.nan);
    }
  }
}
