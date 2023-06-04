/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'ema.dart';
import 'series.dart';
import 'types.dart';

// TODO: refactor this to pass tests with closer accuracy
Series<PriceData> calcTema(
  Series<PriceData> series, {
  int len = 20,
}) {
  final tema = getTema(len: len);

  return series.map(
    (data) => (
      date: data.date,
      value: tema(
        data.value,
      ),
    ),
  );
}

double Function(double) getTema({int len = 20}) {
  final ema1 = getEma(len: len);
  final ema2 = getEma(len: len);
  final ema3 = getEma(len: len);

  return (double data) {
    final ema1Val = ema1(data);
    final ema2Val = ema2(ema1Val);
    final ema3Val = ema3(ema2Val);

    if (ema1Val.isNaN || ema2Val.isNaN || ema3Val.isNaN) {
      return double.nan;
    }

    return (ema1Val * 3) - (ema2Val * 3) + ema3Val;
  };
}
