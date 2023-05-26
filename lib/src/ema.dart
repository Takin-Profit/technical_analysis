// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:collection/collection.dart';

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
  List<double> window = [];
  double? lastEma;
  double alpha = 2 / (len + 1);

  double calculateEma(double data) {
    window.add(data);
    if (window.length > len) {
      var _ = window.removeAt(0);
    }
    if (lastEma == null && window.length == len) {
      lastEma = window.average;
    } else if (lastEma != null) {
      lastEma = alpha * data + (1 - alpha) * lastEma!;
    }

    return lastEma ?? double.nan;
  }

  return calculateEma;
}
