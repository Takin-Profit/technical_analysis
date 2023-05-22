/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

/*
//input = price, default is closing price
//period = linear regression period, default is 9
//pcAbove = percent above, default is .009
//pcBelow = percent below, default is .009
//index = current bar number

price = getPrice(index, input, 0);
linReg = linRegLine(index, period, input, period)[0]; //end point of lin. reg. line
plot1: linReg;
plot2: price;
//Signals
pcAbove = 1 + pcAbove/100.0;
pcBelow = 1 - pcBelow/100.0;
sell = price moreThan; linReg * pcAbove;
buy = price lessThan; linReg * pcBelow;
 */
/*
import 'circular_buffer.dart';
import 'types.dart';

class SimpleLinearRegression {
  late double slope;
  late double intercept;

  SimpleLinearRegression(List<double> x, List<double> y) {
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

Stream<PriceDataDouble> calcLinReg(Stream<PriceDataDouble> seriesStream,
    {int lookBack = 9, double pcAbove = .009, double pcBelow = .009}) async* {
  CircularBuffer<PriceDataDouble> buffer =
      CircularBuffer<PriceDataDouble>(lookBack);

  await for (PriceDataDouble series in seriesStream) {
    buffer.add(series);

    if (buffer.length < lookBack) {
      continue;
    }

    List<double> x = List.generate(buffer.length, (index) => index.toDouble());
    List<double> y = buffer.map((item) => item.value).toList();

    SimpleLinearRegression lr = SimpleLinearRegression(x, y);

    double linReg = lr.predict((buffer.length - 1).toDouble());

    double pcAboveVal = 1 + pcAbove / 100.0;
    double pcBelowVal = 1 - pcBelow / 100.0;
    bool sell = buffer.last.value > linReg * pcAboveVal;
    bool buy = buffer.last.value < linReg * pcBelowVal;

    PriceDataDouble newPriceData = (
      date: buffer.last.date,
      value: buffer.last.value,
      linReg: linReg,
      sell: sell,
      buy: buy
    );

    yield newPriceData;
  }
}


 */
