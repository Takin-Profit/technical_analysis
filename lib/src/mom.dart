/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'series.dart';
import 'types.dart';

Series<PriceData> calcMom(
  Series<PriceData> series, {
  int len = 20,
}) {
  final mom = getMom(len: len);

  return series.map(
    (data) => (
      date: data.date,
      value: mom(
        data.value,
      ),
    ),
  );
}

double Function(double) getMom({int len = 20}) {
  double prevPrice = double.nan;
  int counter = 0;

  return (double close) {
    if (close.isNaN) {
      return close;
    }

    counter++;

    if (counter <= len) {
      if (counter == len) {
        prevPrice = close;
      }

      return double.nan;
    } else {
      double mom = close - prevPrice;
      prevPrice = close;

      return mom;
    }
  };
}
