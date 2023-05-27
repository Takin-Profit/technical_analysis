// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'series.dart';
import 'types.dart';

Series<PriceData> calcEMA(
  Series<PriceData> series, {
  int len = 14,
}) async* {
  final ema = getEma(len: len);

  await for (final data in series) {
    yield (date: data.date, value: ema(data.value));
  }
}

double Function(double data) getEma({int len = 20}) {
  double? lastEma;
  double alpha = 2 / (len + 1);
  int counter = 0;
  double sum = 0;

  return (double data) {
    counter++;
    sum += data;

    // calculate initial SMA to be used as the first EMA
    if (lastEma == null && counter == len) {
      lastEma = sum / len;
    } else if (lastEma != null) {
      lastEma = alpha * data + (1 - alpha) * lastEma!;
    }

    return lastEma ?? double.nan;
  };
}
