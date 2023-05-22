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
  final divisor = lookBack.toDouble() * (lookBack + 1) / 2.0;

  await for (var data in series) {
    buffer.add(data);
    if (buffer.isFilled) {
      double sum = 0.0;
      for (var i = 0; i < lookBack; i++) {
        var weight = lookBack - i;
        sum += buffer[lookBack - i - 1].value * weight;
      }
      yield (date: data.date, value: sum / divisor);
    } else {
      yield (date: data.date, value: double.nan);
    }
  }
}
