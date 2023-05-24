/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'circular_buffer.dart';
import 'series.dart';
import 'types.dart';

Series<PriceData> calcPercentRank(
  Series<PriceData> series, {
  int lookBack = 2,
}) async* {
  final buffer = CircularBuffer<double>(lookBack);

  await for (final data in series) {
    buffer.add(data.value);

    if (buffer.isFilled) {
      int count = buffer.fold(
        0,
        (prev, element) => prev + (element <= data.value ? 1 : 0),
      );
      double percentRank = count / lookBack;
      yield (date: data.date, value: percentRank);
    }
  }
}
