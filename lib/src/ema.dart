// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'types.dart';

Stream<PriceDataDouble> calcEMA(Stream<PriceDataDouble> series,
    {int lookBack = 14}) async* {
  double ema = double.nan;
  double multiplier =
      2 / (lookBack + 1); // Multiplier: (2 / (Time periods + 1) )

  await for (PriceDataDouble data in series) {
    if (ema.isNaN) {
      ema = data.value; // Initial EMA: use the first data point
    } else {
      ema = (data.value - ema) * multiplier +
          ema; // EMA: {Close - EMA(previous day)} x multiplier + EMA(previous day)
    }

    yield (date: data.date, value: ema);
  }
}
