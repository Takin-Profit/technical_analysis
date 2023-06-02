/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'dart:math';

import 'circular_buf.dart';
import 'series.dart';
import 'types.dart';

Series<PriceData> calcAlma(
  Series<PriceData> series, {
  int len = 9,
  double offset = 0.85,
  double sigma = 6,
}) {
  final alma = getAlma(len: len, offset: offset, sigma: sigma);

  return series.map(
    (data) => (
      value: alma(data.value),
      date: data.date,
    ),
  );
}

Function getAlma({
  int len = 20,
  double offset = 0.85,
  double sigma = 6,
}) {
  final window = CircularBuf(size: len);
  final int windowSize = len;
  final double m = offset * (windowSize - 1);
  final double s = windowSize / sigma;

  double calculateAlma(double data) {
    window.put(data);

    if (window.filledSize < len) {
      return double.nan;
    }

    double norm = 0.0;
    double sum = 0.0;
    for (int i = 0; i < windowSize; i++) {
      double weight = exp(-1 * pow(i - m, 2) / (2 * pow(s, 2)));
      norm += weight;
      final int currentIndex = (window.filledSize - i - 1) % len;
      double currentVal = window.orderedValues.elementAt(currentIndex);
      sum += currentVal * weight;
    }

    return sum / norm;
  }

  return calculateAlma;
}
