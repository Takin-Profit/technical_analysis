// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'series.dart';
import 'sma.dart';
import 'types.dart';

/// Moving average used in RSI. It is the exponentially weighted moving average with alpha = 1 / length.
/// requires about 100 quotes before higher accuracy kicks in.
/// recommended warmup periods = 150
Series<PriceData> calcRMA(
  Series<PriceData> series, {
  int len = 14,
}) {
  final rma = getRMA(len: len);

  return series.map((data) => (date: data.date, value: rma(data.value)));
}

double Function(double) getRMA({int len = 14}) {
  double alpha = 1.0 / len;
  double sum = double.nan;
  var getSmaFn = getSMA(len: len);
  bool isInitialSmaCalculated = false;

  return (double data) {
    double sma = getSmaFn(data);
    if (!isInitialSmaCalculated) {
      // Try to calculate initial SMA
      if (!sma.isNaN) {
        // If SMA calculation returned a number, it means initial SMA is calculated
        sum = sma;
        isInitialSmaCalculated = true;
      }
    } else {
      // Apply RMA calculation
      sum = alpha * data + (1 - alpha) * sum;
    }

    return sum;
  };
}
