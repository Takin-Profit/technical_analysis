/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'dart:math';

import 'circular_buffer.dart';
import 'series.dart';
import 'types.dart';

Series<PriceData> calcAlma(
  Series<PriceData> series, {
  int lookBack = 9,
  double offset = 0.85,
  double sigma = 6,
}) async* {
  CircularBuffer<PriceData> buffer = CircularBuffer<PriceData>(lookBack);

  await for (PriceData data in series) {
    buffer.add(data);

    if (buffer.length == lookBack) {
      double m = offset * (lookBack - 1);
      double s = lookBack / sigma;
      double norm = 0.0;
      double sum = 0.0;

      for (int i = 0; i < lookBack; i++) {
        double weight = exp(-pow(i - m, 2) / (2 * pow(s, 2)));
        norm += weight;
        sum += buffer[lookBack - i - 1].value * weight;
      }

      double almaValue = sum / norm;
      yield (value: almaValue, date: data.date);
    } else {
      yield (value: double.nan, date: data.date);
    }
  }
}
