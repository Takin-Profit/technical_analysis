/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'dart:math';

import 'circular_buf.dart';
import 'series.dart';
import 'types.dart';

double _sma(List<double> data, int period) {
  return data.sublist(max(0, data.length - period)).reduce((a, b) => a + b) /
      period;
}

double _stdev(List<double> data, int period) {
  double mean = _sma(data, period);
  double sum = data
      .sublist(max(0, data.length - period))
      .map((v) => pow(v - mean, 2))
      .reduce((a, b) => a + b)
      .toDouble();

  return sqrt(sum / period);
}

Series<PriceData> calcBBW(
  Series<PriceData> series, {
  int lookBack = 5,
  int multi = 4,
}) async* {
  final buf = CircularBuf(size: lookBack);

  await for (final data in series) {
    buf.put(data.value);

    if (buf.isFull) {
      double basis = _sma(buf.values, lookBack);
      double dev = multi * _stdev(buf.values, lookBack);
      double bbwValue = (dev * 2) / basis;
      yield (value: bbwValue, date: data.date);
    } else {
      yield (value: double.nan, date: data.date);
    }
  }
}
