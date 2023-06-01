// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
import 'dart:math';

import 'series.dart';
import 'types.dart';

Series<PriceData> calcRSI(
  Series<PriceData> series, {
  int len = 14,
}) {
  final rsi = getRSI(len: len);

  return series.map((data) => (date: data.date, value: rsi(data.value)));
}

double Function(double) getRSI({int len = 14}) {
  double lastValue = double.nan;
  double avgGain = 0.0;
  double avgLoss = 0.0;
  int count = 0;

  return (double currentValue) {
    double gain = 0.0;
    double loss = 0.0;

    if (!lastValue.isNaN) {
      double change = currentValue - lastValue;
      gain = max(0, change);
      loss = max(0, -change);
    }

    if (count < len) {
      // Calculating the first average gain and loss
      avgGain = ((avgGain * count) + gain) / (count + 1);
      avgLoss = ((avgLoss * count) + loss) / (count + 1);
    } else {
      // Calculating the subsequent average gain and loss
      avgGain = ((avgGain * (len - 1)) + gain) / len;
      avgLoss = ((avgLoss * (len - 1)) + loss) / len;
    }

    count++;
    lastValue = currentValue;

    if (count < len) {
      return double.nan;
    } else {
      double rs = avgGain / avgLoss;

      return 100 - (100 / (rs + 1));
    }
  };
}
