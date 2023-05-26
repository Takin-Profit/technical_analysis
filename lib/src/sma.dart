// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'circular_buf.dart';
import 'series.dart';
import 'types.dart';

Series<PriceData> calcSMA(
  Series<PriceData> series, {
  int len = 20,
}) async* {
  final sma = getSma(len: len);

  await for (final data in series) {
    yield (date: data.date, value: sma(data.value));
  }
}

double Function(double) getSma({int len = 20}) {
  CircularBuf buffer = CircularBuf(size: len);
  double sum = 0.0;

  double calculateSma(double data) {
    if (buffer.isFull) {
      sum -= buffer.first; // Subtract the first item in the buffer
    }

    buffer.put(data);
    sum += data; // Add the new item to the sum

    if (!buffer.isFull) {
      return double.nan; // Not enough data yet
    }

    return sum / len;
  }

  return calculateSma;
}
