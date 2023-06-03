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

TaFunc getKama({int len = 10}) {
  final priceChanges = CircularBuf(size: len);
  double prevClose = double.nan;
  double kama = double.nan;

  // Constants for Fast and Slow EMA
  final double fastEmaConstant = 2 / (2 + 1);
  final double slowEmaConstant = 2 / (30 + 1);

  return (double close) {
    if (close.isNaN) {
      return close;
    }

    // Calculate the absolute price change and add it to the buffer
    if (!prevClose.isNaN) {
      priceChanges.put(close - prevClose);
    }

    prevClose = close;

    if (priceChanges.filledSize < len) {
      return double.nan;
    }

    double change = close - priceChanges.values.first;
    double volatility =
        priceChanges.orderedValues.fold(0, (a, b) => a + b.abs());

    // Calculate the Efficiency Ratio (ER)
    double er = volatility != 0 ? (change / volatility).abs() : 1.0;

    // Calculate the Smoothing Constant (SC)
    double sc =
        pow((er * (fastEmaConstant - slowEmaConstant) + slowEmaConstant), 2)
            .toDouble();

    // Calculate KAMA
    kama = kama.isNaN ? close : kama + sc * (close - kama);

    return kama;
  };
}
