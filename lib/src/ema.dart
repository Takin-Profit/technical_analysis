// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'circular_buffers.dart';
import 'series.dart';
import 'types.dart';

Series<PriceData> calcEMA(
  Series<PriceData> series, {
  int lookBack = 14,
}) async* {
  final buffer = CircularBuffer<PriceData>(lookBack);
  double ema = double.nan;
  final double multiplier =
      2 / (lookBack + 1); // Multiplier: (2 / (Time periods + 1) )

  await for (final data in series) {
    buffer.add(data);

    if (buffer.isFilled) {
      ema = ema.isNaN
          ? buffer.map((el) => el.value).reduce((prev, next) => prev + next) /
              lookBack
          : (data.value - ema) * multiplier + ema;

      yield (date: data.date, value: ema);
    } else {
      // Not enough data to calculate EMA
      yield (date: data.date, value: double.nan);
    }
  }
}
