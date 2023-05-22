/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'circular_buffer.dart';
import 'series.dart';
import 'types.dart';

class _SimpleLinearRegression {
  late double slope;
  late double intercept;

  _SimpleLinearRegression(List<double> x, List<double> y) {
    if (x.length != y.length) {
      throw Exception('Input vectors should have the same length');
    }

    double xSum = 0, ySum = 0, xxSum = 0, xySum = 0;
    for (int i = 0; i < x.length; i++) {
      xSum += x[i];
      ySum += y[i];
      xxSum += x[i] * x[i];
      xySum += x[i] * y[i];
    }

    slope = (x.length * xySum - xSum * ySum) / (x.length * xxSum - xSum * xSum);
    intercept = (ySum - slope * xSum) / x.length;
  }

  double predict(double x) => slope * x + intercept;
}

Series<PriceDataDouble> calcLinReg(
  Series<PriceDataDouble> series, {
  int lookBack = 9,
  // double pcAbove = 0.009,
  // double pcBelow = 0.009,
}) async* {
  CircularBuffer<PriceDataDouble> buffer =
      CircularBuffer<PriceDataDouble>(lookBack);

  await for (PriceDataDouble data in series) {
    buffer.add(data);

    if (buffer.isFilled) {
      List<double> x = List.generate(
        buffer.length,
        (index) => index.toDouble(),
      );
      List<double> y = buffer.map((item) => item.value).toList();

      _SimpleLinearRegression lr = _SimpleLinearRegression(x, y);

      double linReg = lr.predict((buffer.length - 1).toDouble());

      // double pcAboveVal = 1 + pcAbove / 100.0;
      // double pcBelowVal = 1 - pcBelow / 100.0;
      // final last = buffer.last.value;
      // bool sell = last > linReg * pcAboveVal;
      // bool buy = last < linReg * pcBelowVal;

      yield (
        date: data.date,
        value: linReg,
      );
    } else {
      yield (
        date: data.date,
        value: double.nan,
      );
    }
  }
}
