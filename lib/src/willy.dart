/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import "dart:math";

import 'circular_buf.dart';
import 'types.dart';

Stream<PriceData> calcWilly(Stream<PriceData> series) async* {
  final willy = getWilly();

  await for (final data in series) {
    yield (date: data.date, value: willy(data.value));
  }
}

double Function(double) getWilly({int len = 6}) {
  final buffer = CircularBuf(size: len);

  return (double data) {
    buffer.put(data);

    if (buffer.isFull) {
      double high = buffer.values.reduce(max);
      double low = buffer.values.reduce(min);

      return 60 * (data - high) / (high - low) + 80;
    } else {
      return double.nan;
    }
  };
}
