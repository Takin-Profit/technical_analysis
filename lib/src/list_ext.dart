/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'dart:math';

import 'types.dart';

extension Indicators on List<double> {
  double alma({
    double offset = 0.85,
    double sigma = 6,
  }) {
    int windowSize = length;
    double m = offset * (windowSize - 1);
    double s = windowSize / sigma;
    double norm = 0.0;
    double sum = 0.0;
    for (int i = 0; i < windowSize; i++) {
      double weight = exp(-1 * pow(i - m, 2) / (2 * pow(s, 2)));
      norm += weight;
      sum += this[windowSize - i - 1] * weight;
    }

    return sum / norm;
  }
}

extension PriceDataIndicators on List<PriceData> {
  double alma({
    double offset = 0.85,
    double sigma = 6,
  }) {
    final nums = map((data) => data.value).toList();
    int windowSize = length;
    double m = offset * (windowSize - 1);
    double s = windowSize / sigma;
    double norm = 0.0;
    double sum = 0.0;
    for (int i = 0; i < windowSize; i++) {
      double weight = exp(-1 * pow(i - m, 2) / (2 * pow(s, 2)));
      norm += weight;
      sum += nums[windowSize - i - 1] * weight;
    }

    return sum / norm;
  }
}
