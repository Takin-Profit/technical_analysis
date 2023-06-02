/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'bb.dart';
import 'series.dart';
import 'types.dart';

Series<PriceData> calcBBW(
  Series<PriceData> series, {
  int len = 5,
  int multi = 4,
}) {
  final bbw = getBBW(len: len, multi: multi);

  return series.map(
    (data) => (
      value: bbw(data.value),
      date: data.date,
    ),
  );
}

double Function(double) getBBW({
  int len = 5,
  int multi = 4,
}) {
  final getBBFunc = getBB(len: len, multi: multi);

  return (double value) {
    final bb = getBBFunc(value);

    return bb.avg != 0 ? (bb.upper - bb.lower) / bb.avg : double.nan;
  };
}
