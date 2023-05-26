/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'circular_buf.dart';
import 'list_ext.dart';
import 'series.dart';
import 'types.dart';

Series<PriceData> calcAlma(
  Series<PriceData> series, {
  int lookBack = 9,
  double offset = 0.85,
  double sigma = 6,
}) async* {
  final buf = circularBuf(size: lookBack);

  await for (PriceData data in series) {
    buf.put(data.value);

    if (buf.isFilled) {
      yield (value: buf.alma(offset: offset, sigma: sigma), date: data.date);
    } else {
      yield (value: double.nan, date: data.date);
    }
  }
}
