/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'series.dart';
import 'types.dart';

Series<PriceData> calcEMA(
  Series<PriceData> series, {
  int len = 14,
}) {
  final ema = getEma(len: len);

  return series.map((val) {
    return (
      date: val.date,
      value: ema(
        val.value,
      ),
    );
  });
}

double Function(double data) getEma({int len = 20}) {
  double ema = double.nan;
  double alpha = 2 / (len + 1);
  int counter = 0;

  double sum = 0;
  bool smaCalculated = false;

  return (double data) {
    if (!smaCalculated && !data.isNaN) {
      counter++;
      sum += data;
    }
    if (data.isNaN) {
      return data;
    }

    if (!smaCalculated && counter == len) {
      double sma = sum / len;
      if (!sma.isNaN) {
        ema = sma;
        smaCalculated = true;
      }
    } else if (smaCalculated && !data.isNaN) {
      ema = (data - ema) * alpha + ema;
    }

    return ema;
  };
}
