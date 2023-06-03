/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'ema.dart';
import 'series.dart';
import 'types.dart';

Series<PriceData> calcDema(Series<PriceData> series, {int len = 20}) {
  final dema = getDema(len: len);

  return series.map(
    (data) => (
      date: data.date,
      value: dema(
        data.value,
      ),
    ),
  );
}

TaFunc getDema({int len = 20}) {
  final ema1 = getEma(len: len);
  final ema2 = getEma(len: len);

  return (double data) {
    final ema1Val = ema1(data);
    final ema2Val = ema2(ema1Val);

    if (ema1Val.isNaN || ema2Val.isNaN) {
      return double.nan;
    }

    return ema1Val * 2 - ema2Val;
  };
}
