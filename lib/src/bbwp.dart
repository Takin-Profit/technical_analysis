/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'bbw.dart';
import 'percent_rank.dart';
import 'series.dart';
import 'types.dart';

Series<PriceData> calcBbwp(Series<PriceData> series, {int len = 13}) {
  final bbwp = getBbwp(len: len);

  return series.map(
    (data) => (
      date: data.date,
      value: bbwp(
        data.value,
      ),
    ),
  );
}

double Function(double) getBbwp({
  int len = 20,
}) {
  final percentRank = getPercentRank(len: 252);
  final bbw = getBBW(len: len, multi: 1);

  return (double data) {
    final bbwValue = bbw(data);

    return percentRank(bbwValue);
  };
}
