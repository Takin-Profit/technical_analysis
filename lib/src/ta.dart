// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
import 'ema.dart';
import 'rma.dart';
import 'series.dart';
import 'sma.dart';
import 'types.dart';

void _validateArg(String indicator, int value) {
  if (value < 0) {
    throw ArgumentError(
        'LookBack must be greater than 0 to calculate the $indicator');
  }
}

sealed class TA {
  static void na() {}
  static void nz() {}
  static double change() {
    return 0;
  }

  static Series<PriceDataDouble> sma(Series<PriceDataDouble> series,
      {int lookBack = 20}) {
    _validateArg('SMA (Simple Moving Average)', lookBack);
    return calcSMA(series, lookBack: lookBack);
  }

  static Series<PriceDataDouble> rma(Stream<PriceDataDouble> series,
      {int lookBack = 14}) {
    _validateArg('RMA (Relative Moving Average)', lookBack);
    return calcRMA(series, lookBack: lookBack);
  }

  static Series<PriceDataDouble> ema(Stream<PriceDataDouble> series,
      {int lookBack = 20}) {
    _validateArg('EMA (Exponential Moving Average)', lookBack);
    return calcEMA(series, lookBack: lookBack);
  }
}
