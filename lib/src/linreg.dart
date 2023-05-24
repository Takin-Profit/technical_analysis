/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'circular_buffer.dart';
import 'series.dart';
import 'types.dart';
import 'util.dart';

Series<PriceData> calcLinReg(
  Series<PriceData> series, {
  int lookBack = 9,
  // double pcAbove = 0.009,
  // double pcBelow = 0.009,
}) async* {
  CircularBuffer<PriceData> buffer = CircularBuffer<PriceData>(lookBack);

  await for (PriceData data in series) {
    buffer.add(data);

    if (buffer.isFilled) {
      List<double> x = List.generate(
        buffer.length,
        (index) => index.toDouble(),
      );
      List<double> y = buffer.map((item) => item.value).toList();

      SimpleLinearRegression lr = SimpleLinearRegression(x, y);

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
