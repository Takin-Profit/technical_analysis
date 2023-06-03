/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */
import 'dart:math';

import 'series.dart';
import 'types.dart';
import 'wma.dart';

Series<PriceData> calcHma(
  Series<PriceData> series, {
  int len = 16,
}) {
  final hma = getHma(len: len);

  return series.map(
    (data) => (
      date: data.date,
      value: hma(
        data.value,
      ),
    ),
  );
}

TaFunc getHma({int len = 16}) {
  final wmaN = getWma(len: len);
  final wmaNby2 = getWma(len: len ~/ 2);
  final wmaSqrtN = getWma(len: (sqrt(len).round()));

  return (double data) {
    final wmaNVal = wmaN(data);
    final wmaNby2Val = wmaNby2(data);

    if (wmaNVal.isNaN || wmaNby2Val.isNaN) {
      return double.nan;
    }

    final rawHma = wmaNby2Val * 2 - wmaNVal;

    return wmaSqrtN(rawHma);
  };
}
