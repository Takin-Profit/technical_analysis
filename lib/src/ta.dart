// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
import 'ema.dart';
import 'rma.dart';
import 'rsi.dart';
import 'series.dart';
import 'sma.dart';
import 'types.dart';
import 'util.dart';

void _validateArg(String indicator, int value) {
  if (value < 0) {
    throw ArgumentError(
        'LookBack must be greater than 0 to calculate the $indicator');
  }
}

sealed class TA {
  /// This function is the same as double.isNaN property and exists only to
  /// match the tradingview api.
  static bool na(double value) {
    return value.isNaN;
  }

  /// Replaces NaN values with zeros (or given value) in a series.
  /// https://www.tradingview.com/pine-script-reference/v5/#fun_nz
  static double nz(double value, {double replaceWith = 0}) {
    return Util.nz(value, replaceWith: replaceWith);
  }

  /// Compares the current [series] value to its value [length] bars ago and returns the difference.
  static Series<double> change(Series<PriceDataDouble> series,
      {int length = 1}) {
    if (length < 1) {
      throw ArgumentError(
          'Length must be greater than 0 to calculate the change');
    }
    return Util.change(series, length: length);
  }

  static Series<PriceDataDouble> sma(Series<PriceDataDouble> series,
      {int lookBack = 20}) {
    _validateArg('SMA (Simple Moving Average)', lookBack);
    return calcSMA(series, lookBack: lookBack);
  }

  /// Moving average used in RSI. It is the exponentially weighted moving average with alpha = 1 / length.
  /// recommended warmup periods = 150.
  static Series<PriceDataDouble> rma(Series<PriceDataDouble> series,
      {int lookBack = 14}) {
    _validateArg('RMA (Relative Moving Average)', lookBack);
    return calcRMA(series, lookBack: lookBack);
  }

  static Series<PriceDataDouble> ema(Series<PriceDataDouble> series,
      {int lookBack = 20}) {
    _validateArg('EMA (Exponential Moving Average)', lookBack);
    return calcEMA(series, lookBack: lookBack);
  }

  static Series<PriceDataDouble> rsi(Series<PriceDataDouble> series,
      {int lookBack = 14}) {
    _validateArg('RSI (Relative Strength Index)', lookBack);
    return calcRSI(series, lookBack: lookBack);
  }
}
