/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'circular_buf.dart';
import 'series.dart';
import 'types.dart';

Series<PriceData> calcEr(Series<PriceData> series, {int len = 10}) {
  final er = getEr(len: len);

  return series.map(
    (data) => (
      date: data.date,
      value: er(
        data.value,
      ),
    ),
  );
}

double Function(double) getEr({int len = 10}) {
  final buf = CircularBuf(size: len + 1);

  return (double price) {
    buf.put(price);

    if (!buf.isFull) {
      return double.nan;
    }

    double totalAbsChange = 0.0;
    double prevPrice = buf.orderedValues.first;

    for (final currentPrice in buf.orderedValues.skip(1)) {
      totalAbsChange += (currentPrice - prevPrice).abs();
      prevPrice = currentPrice;
    }

    final netChange = price - buf.orderedValues.first;

    return totalAbsChange != 0 ? (netChange / totalAbsChange) * 100 : 0.0;
  };
}
