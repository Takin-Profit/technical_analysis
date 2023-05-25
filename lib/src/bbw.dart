/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'dart:math';

import 'circular_buffer.dart';
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

Series<PriceData> bbw(
  Series<PriceData> series, {
  int lookBack = 5,
  int multi = 4,
}) async* {
  final buffer = CircularBuffer<double>(lookBack);

  await for (final data in series) {
    buffer.add(data.value);
    if (buffer.length >= lookBack) {
      double basis = _sma(buffer.toList(), lookBack);
      double dev = multi * _stdev(buffer.toList(), lookBack);
      double bbwValue = ((basis + dev) - (basis - dev)) / basis;
      yield (value: bbwValue, date: data.date);
    }
  }
}
