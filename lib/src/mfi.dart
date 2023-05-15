// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// ignore_for_file: prefer-moving-to-variable,no-magic-number

import 'circular_buffer.dart';
import 'series.dart';
import 'types.dart';

Series<PriceDataDouble> calcMFI(Series<({DateTime date, double value, double vol})> series, {int lookBack = 14})
 async* {
  final buffer = CircularBuffer<({DateTime date, double value, double vol})>(lookBack);
  final changeBuffer = CircularBuffer<PriceDataDouble>(lookBack);

  ({DateTime date, double value, double vol})? previous;

  await for (var data in series) {
    buffer.add(data);

    if (previous != null) {
      final changeValue = (date: data.date, value: data.value - previous.value);
      changeBuffer.add(changeValue);
    }
    previous = data;

    if (buffer.isFilled) {
      double upper = 0;
      double lower = 0;

      for (var changeData in changeBuffer) {
        double volume = buffer.firstWhere((element) => element.date == changeData.date).vol;
        if (changeData.value > 0) {
          upper += changeData.value * volume;
        } else {
          lower += changeData.value.abs() * volume;
        }
      }

      double mfi = 100 - (100 / (1 + upper / lower));

      yield (date: data.date, value: mfi);
    } else {
      yield (date: data.date, value: double.nan);
    }
  }
}
