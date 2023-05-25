/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'circular_buffers.dart';
import 'list_ext.dart';
import 'series.dart';
import 'types.dart';

Series<PriceData> calcAlma(
  Series<PriceData> series, {
  int lookBack = 9,
  double offset = 0.85,
  double sigma = 6,
}) async* {
  CircularBuffer<double> buffer = CircularBuffer<double>(lookBack);

  await for (PriceData data in series) {
    buffer.add(data.value);

    if (buffer.isFilled) {
      yield (value: buffer.alma(offset: offset, sigma: sigma), date: data.date);
    } else {
      yield (value: double.nan, date: data.date);
    }
  }
}
