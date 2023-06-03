/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'circular_buf.dart';
import 'series.dart';
import 'types.dart';

Series<PriceData> calcWMA(
  Series<PriceData> series, {
  int len = 15,
}) {
  final wma = getWma(len: len);

  return series.map((data) => (date: data.date, value: wma(data.value)));
}

TaFunc getWma({int len = 15}) {
  final buffer = CircularBuf(size: len);
  final divisor = len.toDouble() * (len + 1) / 2.0;

  return (double data) {
    buffer.put(data);

    if (buffer.isFull) {
      double sum = 0.0;
      for (var i = 0; i < len; i++) {
        var weight = len - i;
        sum += buffer.orderedValues.elementAt(len - i - 1) * weight;
      }

      return sum / divisor;
    } else {
      return double.nan;
    }
  };
}
