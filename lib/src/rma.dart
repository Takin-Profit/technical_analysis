// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'circular_buffer.dart';
import 'series.dart';
import 'types.dart';

/// Moving average used in RSI. It is the exponentially weighted moving average with alpha = 1 / length.
/// requires about 100 quotes before higher acuracy kicks in.
/// recommended warmup periods = 150
Series<PriceDataDouble> calcRMA(
  Series<PriceDataDouble> series, {
  int lookBack = 14,
}) async* {
  final double alpha = 1.0 / lookBack;
  double? sum;
  final buf = CircularBuffer<PriceDataDouble>(lookBack);

  await for (final data in series) {
    buf.add(data);
    if (buf.isFilled && sum == null) {
      // Calculate initial SMA
      sum = buf.map((el) => el.value).reduce((prev, next) => prev + next) /
          lookBack;
    } else if (sum != null) {
      // Apply RMA calculation
      sum = alpha * data.value + (1 - alpha) * sum;
    }

    yield (date: data.date, value: sum ?? double.nan);
  }
}
