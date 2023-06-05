/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'dart:math';

import 'rma.dart';
import 'types.dart';

double Function(HLC) calcAtr({int len = 14}) {
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
