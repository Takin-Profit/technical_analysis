/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */
import 'package:collection/collection.dart';

import 'circular_buf.dart';
import 'series.dart';
import 'types.dart';

Series<PriceData> calcSmma(Series<PriceData> series, {int len = 20}) {
  final smma = getSmma(len: len);

  return series.map(
    (data) => (
      date: data.date,
      value: smma(
        data.value,
      ),
    ),
  );
}

double Function(double) getSmma({int len = 20}) {
  final buf = CircularBuf(size: len);
  double smma = 0.0;

  return (double price) {
    buf.put(price);
    smma =
        !buf.isFull ? buf.values.average : ((smma * (len - 1)) + price) / len;

    return smma;
  };
}
