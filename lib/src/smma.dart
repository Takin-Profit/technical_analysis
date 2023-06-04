/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */
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
  double? smma;

  return (double price) {
    buf.put(price);

    if (smma == null) {
      if (buf.isFull) {
        smma = buf.orderedValues.fold(0.0, (a, b) => a + b) / len;
      }
    } else {
      smma = ((smma! * (len - 1)) + price) / len;
    }

    return smma ?? double.nan;
  };
}
