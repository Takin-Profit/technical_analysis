// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
import 'series.dart';
import 'sma.dart';
import 'types.dart';

sealed class TA {
  static void na() {}
  static void nz() {}
  static double change() {
    return 0;
  }

  static Series<PriceDataDouble> sma(Series<PriceDataDouble> series,
      {int lookBack = 20}) {
    return calcSMA(series, lookBack: lookBack);
  }
}
