/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'dart:typed_data';

import 'circular_buf.dart';
import 'series.dart';
import 'types.dart';

Series<PriceData> calcSwma(Series<PriceData> series, {int len = 20}) {
  final swma = getSwma(len: len);

  return series.map(
    (data) => (
      date: data.date,
      value: swma(
        data.value,
      ),
    ),
  );
}

double Function(double) getSwma({int len = 20}) {
  final buf = CircularBuf(size: len);

  return (double price) {
    buf.put(price);

    if (!buf.isFull) {
      return double.nan;
    }

    final allPrices = Float64List.fromList(
      buf.orderedValues.toList(),
    );

    // Compute the SWMA
    double swma = 0;
    for (int i = 0; i < len; ++i) {
      swma += allPrices[i] * (i + 1) / (len * (len + 1) / 2);
    }

    return swma;
  };
}
