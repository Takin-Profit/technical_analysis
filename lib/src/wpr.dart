/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'dart:math';

import 'circular_buf.dart';
import 'series.dart';
import 'types.dart';

Series<PriceData> calcWPR(
  QuoteSeries series, {
  int len = 14,
}) {
  final wpr = getWpr(len: len);

  return series.map((val) => (
        date: val.date,
        value: wpr(
          high: val.high.toDouble(),
          low: val.low.toDouble(),
          close: val.close.toDouble(),
        )
      ));
}

// Instantiate the circular buffers for high and low values
Function getWpr({required int len}) {
  final highestBuffer = CircularBuf(size: len);
  final lowestBuffer = CircularBuf(size: len);
  double lastClose = double.nan;

  return ({required double high, required double low, required double close}) {
    // Put high and low into their respective buffers
    highestBuffer.put(high);
    lowestBuffer.put(low);
    lastClose = close;

    if (highestBuffer.isFull && lowestBuffer.isFull) {
      final highestHigh = highestBuffer.values.reduce(max);
      final lowestLow = lowestBuffer.values.reduce(min);

      return -100 * (highestHigh - lastClose) / (highestHigh - lowestLow);
    } else {
      return double.nan;
    }
  };
}
