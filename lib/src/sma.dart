// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:technical_indicators/src/circular_buffer.dart';
import 'package:technical_indicators/src/series.dart';
import 'package:technical_indicators/src/types.dart';

Series<PriceDataDouble> calcSMA(
  Series<PriceDataDouble> series, {
  int lookBack = 20,
}) async* {
  final buffer = CircularBuffer<PriceDataDouble>(lookBack);

  await for (final data in series) {
    buffer.add(data);

    if (buffer.isFilled) {
      final sma =
          buffer.map((el) => el.value).reduce((prev, next) => prev + next) /
              lookBack;
      yield (date: data.date, value: sma);
    } else {
      yield (date: data.date, value: double.nan);
    }
  }
}
