/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'series.dart';
import 'sma.dart';
import 'std_dev.dart';
import 'types.dart';

typedef BBResult = ({DateTime date, double upper, double lower, double avg});

Series<BBResult> calcBB(
  Series<PriceData> series, {
  int len = 20,
  int multi = 2,
}) async* {
  final bb = getBB(len: len, multi: multi);

  await for (final data in series) {
    final _bb = bb(data.value);

    yield (date: data.date, upper: _bb.upper, lower: _bb.lower, avg: _bb.avg);
  }
}

({double upper, double lower, double avg}) Function(double) getBB({
  int len = 20,
  int multi = 2,
}) {
  int counter = 0;
  final sma = getSma(len: len);
  final stDev = getStDev(len: len);

  return (double value) {
    counter++;
    double avg = sma(value);
    double std = stDev(value);

    return (counter < len)
        ? (upper: double.nan, lower: double.nan, avg: double.nan)
        : (upper: avg + multi * std, lower: avg - multi * std, avg: avg);
  };
}
