/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'dart:math';

import 'series.dart';
import 'types.dart';

Series<PriceData> calcAlma(
  Series<PriceData> series, {
  int len = 9,
  double offset = 0.85,
  double sigma = 6,
}) async* {
  final alma = getAlma(len: len, offset: offset, sigma: sigma);

  await for (PriceData data in series) {
    yield (value: alma(data.value), date: data.date);
  }
}

double Function(double data) getAlma({
  int len = 20,
  double offset = 0.85,
  double sigma = 6,
}) {
  List<double> window = List.filled(len, 0.0);
  int windowSize = len;
  double m = offset * (windowSize - 1);
  double s = windowSize / sigma;
  int dataIndex = 0;

  double calculateAlma(double data) {
    window[dataIndex % len] = data;
    dataIndex++;

    if (dataIndex < len) {
      return double.nan;
    }

    double norm = 0.0;
    double sum = 0.0;
    for (int i = 0; i < windowSize; i++) {
      double weight = exp(-1 * pow(i - m, 2) / (2 * pow(s, 2)));
      norm += weight;
      sum += window[(windowSize - i - 1) % len] * weight;
    }

    return sum / norm;
  }

  return calculateAlma;
}
