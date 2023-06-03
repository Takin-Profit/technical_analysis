/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'dart:math';

import 'er.dart';
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
  final er = getEr(len: len);

  double kama = 0.0;
  final double fast = 0.666666666666667;
  final double slow = 0.0645161290322581;

  return (double price) {
    double erValue = er(price);
    if (erValue.isNaN) {
      return double.nan;
    }

    erValue = erValue.abs();
    double sc = pow(erValue * (fast - slow) + slow, 2).toDouble();

    return kama == 0.0 ? price : sc * (price - kama);
  };
}
