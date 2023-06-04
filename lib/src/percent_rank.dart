/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'circular_buf.dart';
import 'series.dart';
import 'types.dart';

/// requires at least 50 bar warmup period
Series<PriceData> calcPercentRank(
  Series<PriceData> series, {
  int len = 20,
}) {
  final pRank = getPercentRank(len: len);

  return series.map(
    (data) => (
      date: data.date,
      value: pRank(
        data.value,
      ),
    ),
  );
}

double Function(double) getPercentRank({int len = 20}) {
  final CircularBuf buffer = CircularBuf(size: len);

  return (double data) {
    int count = 0;
    double percentRank = double.nan;

    if (buffer.isFull) {
      for (var value in buffer.orderedValues) {
        if (value <= data) {
          count++;
        }
      }

      percentRank = (count * 100.0 / len);
    }

    buffer.put(data);

    return percentRank;
  };
}
