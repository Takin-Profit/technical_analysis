/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'dart:math';

import 'circular_buf.dart';
import 'series.dart';
import 'types.dart';

Series<PriceData> calcStdDev(
  Series<PriceData> series, {
  int len = 20,
  StDevOf bias = StDevOf.population,
}) {
  final stdDev = getStDev(len: len, bias: bias);

  return series.map((data) => (date: data.date, value: stdDev(data.value)));
}

double Function(double) getStDev({
  int len = 20,
  StDevOf bias = StDevOf.population,
}) {
  final buffer = CircularBuf(size: len);
  double sum = 0;
  double sumOfSquares = 0;

  // adjusts the divisor accordingly
  int divisor() {
    return bias == StDevOf.population
        ? len
        : len - 1 > 0
            ? len - 1
            : throw StateError(
                "Cannot calculate sample stdev for buffer of length 1");
  }

  return (double data) {
    double oldVal = buffer.isFull ? buffer.first : 0;

    // update the buffer
    buffer.put(data);

    sum += data - oldVal;
    sumOfSquares += data * data - oldVal * oldVal;

    if (!buffer.isFull) {
      return double.nan;
    }

    double mean = sum / len;
    double meanOfSquares = sumOfSquares / len;
    double variance = meanOfSquares - mean * mean;
    double adjustedVariance =
        variance * len / divisor(); // Adjust variance for bias

    return sqrt(adjustedVariance);
  };
}
