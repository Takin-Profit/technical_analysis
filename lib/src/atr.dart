/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'dart:math';

import 'quotes.dart';
import 'rma.dart';
import 'series.dart';
import 'types.dart';

// requires 150 bar warmup period.
Series<PriceData> calcAtr(
  Series<Quote> series, {
  int len = 14,
}) {
  final atr = getAtr(len: len);

  return series.map(
    (data) => (
      date: data.date,
      value: atr(
        data.hlc,
      ),
    ),
  );
}

double Function(HLC) getAtr({int len = 14}) {
  var prevClose = double.nan;
  final rma = getRMA(len: len);

  return (HLC q) {
    final highLow = q.high - q.low;
    final highClose = !prevClose.isNaN ? (q.high - prevClose).abs() : highLow;
    final lowClose = !prevClose.isNaN ? (q.low - prevClose).abs() : highLow;

    final trueRange = [highLow, highClose, lowClose].reduce(max);
    prevClose = q.close;

    return rma(trueRange);
  };
}
