/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'dart:typed_data';

import 'circular_buf.dart';
import 'series.dart';
import 'types.dart';

Series<PriceData> calcSwma(
  Series<PriceData> series,
) {
  final swma = getSwma();

  return series.map(
    (data) => (
      date: data.date,
      value: swma(
        data.value,
      ),
    ),
  );
}

double Function(double) getSwma() {
  final buf = CircularBuf(size: 4);

  return (double price) {
    buf.put(price);

    // If the buffer isn't full yet, return NaN
    if (!buf.isFull) {
      return double.nan;
    }

    // Retrieve the last four data points
    Float64List lastFourPrices =
        Float64List.fromList(buf.orderedValues.toList());

    // Compute the SWMA
    return (lastFourPrices.first * 1 / 6) +
        (lastFourPrices[1] * 2 / 6) +
        (lastFourPrices[2] * 2 / 6) +
        (lastFourPrices[3] * 1 / 6);
  };
}
