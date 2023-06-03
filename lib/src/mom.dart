/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'circular_buf.dart';
import 'series.dart';
import 'types.dart';

Series<PriceData> calcMom(
  Series<PriceData> series, {
  int len = 20,
}) {
  final mom = getMom(len: len);

  return series.map(
    (data) => (
      date: data.date,
      value: mom(
        data.value,
      ),
    ),
  );
}

double Function(double) getMom({int len = 20}) {
  final prices = CircularBuf(size: len + 1);

  return (double close) {
    if (close.isNaN) {
      return close;
    }

    prices.put(close);

    if (prices.filledSize < len + 1) {
      return double.nan;
    }

    return close - prices.orderedValues.first;
  };
}
