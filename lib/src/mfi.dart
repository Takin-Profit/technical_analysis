/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

// ignore_for_file: prefer-moving-to-variable,no-magic-number

import 'package:collection/collection.dart';

import 'circular_buf.dart';
import 'series.dart';
import 'types.dart';

typedef PriceDataTriple = ({DateTime date, double value, double vol});

Series<PriceData> calcMFI(
  Series<PriceDataTriple> series, {
  int len = 14,
}) {
  final mfi = getMFI(len: len);

  return series.map(
    (data) => (
      date: data.date,
      value: mfi(
        value: data.value,
        vol: data.vol,
      ),
    ),
  );
}

double Function({required double value, required double vol}) getMFI({
  int len = 14,
}) {
  CircularBuf upperBuffer = CircularBuf(size: len);
  CircularBuf lowerBuffer = CircularBuf(size: len);
  double prev = double.nan;

  return ({required double value, required double vol}) {
    double change = prev.isNaN ? 0.0 : value - prev;
    double mf = vol * value; // Raw Money Flow

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

    upperBuffer.put(upper);
    lowerBuffer.put(lower);

    prev = value;

    if (upperBuffer.isFull && lowerBuffer.isFull) {
      double upperSum = upperBuffer.values.sum;
      double lowerSum = lowerBuffer.values.sum;

      if (lowerSum != 0) {
        double mfRatio = upperSum / lowerSum;

        return 100 - (100 / (mfRatio + 1));
      } else {
        return 100;
      }
    } else {
      return double.nan;
    }
  };
}
