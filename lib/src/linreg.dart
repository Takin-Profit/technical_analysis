/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'circular_buf.dart';
import 'series.dart';
import 'types.dart';

Series<PriceData> calcLinReg(
  Series<PriceData> series, {
  int len = 9,
}) {
  final linReg = getLINREG(len: len);

  return series.map(
    (data) => (
      date: data.date,
      value: linReg(
        data.value,
      ),
    ),
  );
}

double Function(double) getLINREG({int len = 9}) {
  CircularBuf buf = CircularBuf(size: len);
  double xSum = 0, ySum = 0, xxSum = 0, xySum = 0;
  int count = 0;

  return (double y) {
    if (y.isNaN) {
      return y;
    }
    double x = count.toDouble();

    if (buf.isFull) {
      double firstY = buf.first;
      double firstX = count - len.toDouble();
      xSum -= firstX;
      ySum -= firstY;
      xxSum -= firstX * firstX;
      xySum -= firstX * firstY;
    }

    xSum += x;
    ySum += y;
    xxSum += x * x;
    xySum += x * y;

    buf.put(y);

    if (count < len - 1) {
      count++;

      return double.nan;
    } else {
      double slope = (len * xySum - xSum * ySum) / (len * xxSum - xSum * xSum);
      double intercept = (ySum - slope * xSum) / len;
      count++;

      return slope * x + intercept;
    }
  };
}
