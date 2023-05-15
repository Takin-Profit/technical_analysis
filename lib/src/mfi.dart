// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// ignore_for_file: prefer-moving-to-variable,no-magic-number

import 'circular_buffer.dart';
import 'series.dart';
import 'types.dart';
import 'util.dart';

Series<PriceDataDouble> calcMFI(Series<({DateTime date, double value, double vol})> series, {int lookBack = 14})
 async* {
  final buffer = CircularBuffer<({DateTime date, double value, double vol})>(lookBack);

  await for (final data in series) {
    buffer.add(data);

    if (buffer.isFilled) {
      double upper = 0;
      double lower = 0;

      final changeStream = Util.change(series.map((event) => (date: event.date, value:event.value)), length: lookBack);
      await for (final changeData in changeStream) {

        upper += changeData.value <= 0 ? 0 : changeData.value * data.vol;
        lower += changeData.value >= 0 ? 0 : changeData.value * data.vol;
      }

      final double mfi = 100 - (100 / (1 + upper / lower));

      yield (date: data.date, value: mfi);
    } else {
      yield (date: data.date, value: double.nan);
    }
  }
}
