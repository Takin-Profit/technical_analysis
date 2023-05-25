// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'circular_buffers.dart';
import 'list_ext.dart';
import 'series.dart';
import 'types.dart';

Series<PriceData> calcSMA(
  Series<PriceData> series, {
  int lookBack = 20,
}) async* {
  final buffer = CircularBuffer<double>(lookBack);

  await for (final data in series) {
    buffer.add(data.value);

    if (buffer.isFilled) {
      yield (date: data.date, value: buffer.sma);
    } else {
      yield (date: data.date, value: double.nan);
    }
  }
}
