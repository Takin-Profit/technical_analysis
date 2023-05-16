// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// ignore_for_file: prefer-moving-to-variable,no-magic-number

import 'package:collection/collection.dart';

import 'circular_buffer.dart';
import 'series.dart';
import 'types.dart';

typedef PriceDataTriple = ({DateTime date, double value, double vol});

Series<PriceDataDouble> calcMFI(
  Series<PriceDataTriple> series, {
  int lookBack = 14,
}) async* {
  final upperBuffer = CircularBuffer<double>(lookBack);
  final lowerBuffer = CircularBuffer<double>(lookBack);
  PriceDataTriple? prev;

  await for (final current in series) {
    final change = (prev == null) || prev.value == current.value
        ? 0.0
        : current.value - prev.value;
    final mf = current.vol * current.value; // Raw Money Flow

    double upper, lower;
    if (change > 0) {
      upper = mf;
      lower = 0.0;
    } else if (change < 0) {
      upper = 0.0;
      lower = mf;
    } else {
      upper = 0.0;
      lower = 0.0;
    }

    upperBuffer.add(upper);
    lowerBuffer.add(lower);

    if (upperBuffer.isFilled && lowerBuffer.isFilled) {
      final lowerSum = lowerBuffer.sum;

      double mfi;
      if (lowerSum != 0) {
        double mfRatio = upperBuffer.sum / lowerSum;
        mfi = 100 - (100 / (mfRatio + 1));
      } else {
        mfi = 100;
      }

      yield (date: current.date, value: mfi);
    } else {
      yield (date: current.date, value: double.nan);
    }

    prev = current;
  }
}
