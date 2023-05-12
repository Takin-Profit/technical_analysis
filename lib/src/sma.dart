// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:technical_indicators/src/circular_buffer.dart';
import 'package:technical_indicators/src/series.dart';
import 'package:technical_indicators/src/types.dart';

// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

Series<PriceData> calcSMA(Series<PriceData> series,
    {int lookBack = 20}) async* {
  final buffer = CircularBuffer<PriceData>(lookBack - 1);

  await for (PriceData data in series) {
    buffer.add(data);

    if (buffer.isFilled) {
      final sma =
          buffer.map((el) => el.value).reduce((prev, next) => prev + next) /
              lookBack;
      yield (date: data.date, value: sma);
    } else {
      yield (date: data.date, value: double.nan);
    }
  }
}
