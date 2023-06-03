/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'dart:math';

import 'circular_buf.dart';
import 'series.dart';
import 'types.dart';

Series<PriceData> calcKama(
  Series<PriceData> series, {
  int len = 10,
}) {
  final kama = getKama(len: len);

  return series.map(
    (data) => (
      date: data.date,
      value: kama(
        data.value,
      ),
    ),
  );
}

double Function(double) getKama({int len = 10}) {
  final prices = CircularBuf(size: len + 1);
  double kama = double.nan;

  // Constants for Fast and Slow EMA
  const fastEmaConstant = 0.666666666666667;
  const slowEmaConstant = 0.0645161290322581;

  return (double close) {
    if (close.isNaN) {
      return close;
    }

    // Add close price to the buffer
    prices.put(close);

    if (prices.filledSize < len + 1) {
      return double.nan;
    }

    // Calculate signal
    double signal = (close - prices.values.elementAt(len)).abs();

    // Calculate noise
    double noise = 0;
    for (int i = 0; i < len; i++) {
      noise +=
          (prices.values.elementAt(i) - prices.values.elementAt(i + 1)).abs();
    }

    // Calculate Efficiency Ratio (ER)
    double er = noise != 0 ? signal / noise : 0;

    // Calculate Smoothing Constant (SC)
    double sc =
        pow((er * (fastEmaConstant - slowEmaConstant) + slowEmaConstant), 2)
            .toDouble();

    // Initialize or Calculate KAMA
    kama = kama.isNaN ? close : kama + sc * (close - kama);

    return kama;
  };
}
