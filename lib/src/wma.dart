/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'circular_buf.dart';
import 'series.dart';
import 'types.dart';

Series<PriceData> calcWMA(
  Series<PriceData> series, {
  int lookBack = 15,
}) async* {
  final buffer = CircularBuf(size: lookBack);
  final divisor = lookBack.toDouble() * (lookBack + 1) / 2.0;

  await for (var data in series) {
    buffer.put(data.value);
    if (buffer.isFull) {
      double sum = 0.0;
      for (var i = 0; i < lookBack; i++) {
        var weight = lookBack - i;
        sum += buffer.values[lookBack - i - 1] * weight;
      }
      yield (date: data.date, value: sum / divisor);
    } else {
      yield (date: data.date, value: double.nan);
    }
  }
}
