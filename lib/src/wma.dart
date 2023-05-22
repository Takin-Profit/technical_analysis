/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'circular_buffer.dart';
import 'series.dart';
import 'types.dart';

Series<PriceDataDouble> calcWMA(
  Series<PriceDataDouble> series, {
  int lookBack = 15,
}) async* {
  final buffer = CircularBuffer<PriceDataDouble>(lookBack);

  await for (var data in series) {
    buffer.add(data);
    if (buffer.length >= lookBack) {
      double sum = 0.0;
      double norm = 0.0;
      for (var i = 0; i < lookBack; i++) {
        final weight = (lookBack - i) * lookBack;
        norm += weight;
        sum += buffer[i].value * weight;
      }
      final wma = sum / norm;
      final date = buffer.last.date;
      yield (date: date, value: wma);
    }
  }
}
