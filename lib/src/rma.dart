// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'sma.dart';
import 'types.dart';

Stream<PriceDataDouble> calcRMA(Stream<PriceDataDouble> series,
    {int lookBack = 14}) async* {
  double alpha = 1 / lookBack;
  double? sum;

  await for (PriceDataDouble data in series) {
    if (sum == null) {
      // Calculate SMA for the first 'length' elements
      final smaSeries = Stream.fromIterable([data]);
      await for (PriceDataDouble smaData
          in calcSMA(smaSeries, lookBack: lookBack)) {
        sum = smaData.value;
      }
      yield (date: data.date, value: sum!);
    } else {
      // Calculate RMA for the rest of the elements
      sum = alpha * data.value + (1 - alpha) * sum;
    }

    yield (date: data.date, value: sum);
  }
}
