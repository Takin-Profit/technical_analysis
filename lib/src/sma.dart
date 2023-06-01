// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:collection/collection.dart';

import 'circular_buf.dart';
import 'series.dart';
import 'types.dart';

Series<PriceData> calcSMA(
  Series<PriceData> series, {
  int len = 20,
}) {
  final sma = getSMA(len: len);

  return series.map((data) => (date: data.date, value: sma(data.value)));
}

double Function(double) getSMA({int len = 20}) {
  CircularBuf buffer = CircularBuf(size: len);

  return (double data) {
    buffer.put(data);

    return buffer.isFull ? buffer.values.average : double.nan;
  };
}
