/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'dart:math';

import 'quotes.dart';
import 'series.dart';
import 'types.dart';

Series<PriceData> calcTr(
  Series<Quote> series, {
  bool handleNa = true,
}) {
  final tr = getTr(handleNa: handleNa);

  return series.map(
    (data) => (
      date: data.date,
      value: tr(
        data.hlc,
      ),
    ),
  );
}

double Function(HLC) getTr({bool handleNa = true}) {
  double prevClose = double.nan;

  return (HLC q) {
    double trueRange;

    if (prevClose.isNaN && handleNa) {
      trueRange = q.high -
          q.low; // If prevClose is null and handleNa is true, calculate as high-low
    } else if (!prevClose.isNaN) {
      double highClose = (q.high - prevClose).abs();
      double lowClose = (q.low - prevClose).abs();

      trueRange = max(q.high - q.low, max(highClose, lowClose));
    } else {
      trueRange =
          double.nan; // If prevClose is null and handleNa is false, return NaN
    }

    prevClose = q.close;

    return trueRange;
  };
}
