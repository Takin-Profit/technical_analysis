// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
import 'dart:math';

import 'circular_buffer.dart';
import 'series.dart';
import 'types.dart';

Series<PriceDataDouble> calcRSI(
  Series<PriceDataDouble> series, {
  int lookBack = 14,
}) async* {
  final gainBuffer = CircularBuffer<double>(lookBack);
  final lossBuffer = CircularBuffer<double>(lookBack);

  double? lastValue;
  double avgGain = 0;
  double avgLoss = 0;

  await for (final current in series) {
    double gain = 0;
    double loss = 0;

    if (lastValue != null) {
      final double change = current.value - lastValue;
      gain = max(0, change);
      loss = max(0, -change);
    }

    gainBuffer.add(gain);
    lossBuffer.add(loss);

    if (gainBuffer.isFilled) {
      if (avgGain == 0 && avgLoss == 0) {
        avgGain = gainBuffer.reduce((a, b) => a + b) / lookBack;
        avgLoss = lossBuffer.reduce((a, b) => a + b) / lookBack;
      } else {
        avgGain = ((avgGain * (lookBack - 1)) + gain) / lookBack;
        avgLoss = ((avgLoss * (lookBack - 1)) + loss) / lookBack;
      }

      double rsi;
      if (avgLoss > 0) {
        final double rs = avgGain / avgLoss;
        rsi = 100 - (100 / (1 + rs));
      } else {
        rsi = 100;
      }

      yield (date: current.date, value: rsi);
    } else {
      yield (date: current.date, value: double.nan);
    }

    lastValue = current.value;
  }
}
