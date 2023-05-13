// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:technical_indicators/src/circular_buffer.dart';

import 'sma.dart';
import 'types.dart';

Stream<PriceDataDouble> calcRMA(Stream<PriceDataDouble> series,
    {int lookBack = 14}) async* {
  double alpha = 1 / lookBack;
  double sum = double.nan;
  var buffer = CircularBuffer<PriceDataDouble>(lookBack);

  await for (PriceDataDouble data in series) {
    buffer.add(data);

    if (!buffer.isFilled) {
      yield (date: data.date, value: double.nan);
      continue;
    } else if (sum.isNaN) {
      // Calculate SMA for the first 'lookBack' elements
      final smaSeries = Stream.fromIterable(buffer.toList());
      await for (PriceDataDouble smaData
          in calcSMA(smaSeries, lookBack: lookBack)) {
        sum = smaData.value;
      }
    } else {
      // Calculate RMA for the rest of the elements
      sum = alpha * data.value + (1 - alpha) * sum;
    }

    yield (date: data.date, value: sum);
  }
}
