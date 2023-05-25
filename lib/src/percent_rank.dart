/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'circular_buffers.dart';
import 'series.dart';
import 'types.dart';

/// requires at least 50 bar warmup period
Series<PriceData> calcPercentRank(
  Series<PriceData> series, {
  int lookBack = 20,
}) async* {
  final buffer = CircularBuffer<double>(
    lookBack + 1,
  ); // +1 to accommodate the current value

  await for (final data in series) {
    buffer.add(data.value);

    if (buffer.length >= lookBack) {
      int count = 0;
      for (int i = 1; i < lookBack; i++) {
        // start from index 1
        if (buffer[i] <= data.value) {
          count++;
        }
      }
      // Include current value in the count
      if (buffer.first <= data.value) {
        count++;
      }
      double percentRank =
          (count * 100.0 / lookBack); // Divided by lookBack, not lookBack+1
      yield (date: data.date, value: percentRank);
    } else {
      yield (date: data.date, value: 0);
    }
  }
}
