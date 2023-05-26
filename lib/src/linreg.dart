/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'circular_buf.dart';
import 'series.dart';
import 'types.dart';
import 'util.dart';

Series<PriceData> calcLinReg(
  Series<PriceData> series, {
  int lookBack = 9,
  // double pcAbove = 0.009,
  // double pcBelow = 0.009,
}) async* {
  final buf = circularBuf(size: lookBack);

  await for (PriceData data in series) {
    buf.put(data.value);

    if (buf.isFilled) {
      List<double> x = List.generate(
        buf.length,
        (index) => index.toDouble(),
      );

      SimpleLinearRegression lr = SimpleLinearRegression(x, buf);

      double linReg = lr.predict((buf.length - 1).toDouble());

      // double pcAboveVal = 1 + pcAbove / 100.0;
      // double pcBelowVal = 1 - pcBelow / 100.0;
      // final last = buf.last.value;
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
