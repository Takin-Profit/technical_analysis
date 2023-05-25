// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:technical_analysis/src/percent_rank.dart';

import 'alma.dart';
import 'bb.dart';
import 'bbw.dart';
import 'ema.dart';
import 'linreg.dart';
import 'mfi.dart';
import 'phx.dart';
import 'rma.dart';
import 'rsi.dart';
import 'series.dart';
import 'sma.dart';
import 'std_dev.dart';
import 'tci.dart';
import 'tsi.dart';
import 'types.dart';
import 'util.dart';
import 'willy.dart';
import 'wma.dart';
import 'wpr.dart';

void _validateArg(String indicator, int value, int minValue) {
  if (value < minValue) {
    throw ArgumentError(
      'LookBack must be greater than 0 to calculate the $indicator',
    );
  }
}

//
// ignore: prefer-correct-type-name
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
  static Series<PriceData> change(
    Series<PriceData> series, {
    int length = 1,
  }) {
    if (length < 1) {
      throw ArgumentError(
        'Length must be greater than 0 to calculate the change',
      );
    }

    return Util.change(series, length: length);
  }

  static Series<PriceData> highest(
    Series<PriceData> series, {
    int length = 1,
  }) {
    if (length < 1) {
      throw ArgumentError(
        'Length must be greater than 0 to find the highest value',
      );
    }

    return Util.highest(series, length: length);
  }

  static Series<PriceData> lowest(
    Series<PriceData> series, {
    int length = 1,
  }) {
    if (length < 1) {
      throw ArgumentError(
        'Length must be greater than 0 to find the lowest value',
      );
    }

    return Util.lowest(series, length: length);
  }

  static Series<PriceData> percentRank(
    Series<PriceData> series, {
    int lookBack = 2,
  }) {
    _validateArg('Percent Rank', lookBack, 2);

    return calcPercentRank(series, lookBack: lookBack);
  }

  static Series<PriceData> stdDev(
    Series<PriceData> series, {
    int length = 1,
    StDev bias = StDev.population,
  }) {
    if (length < 1) {
      throw ArgumentError(
        'Length must be greater than 0 to calculate the standard deviation',
      );
    }

    return calcStdDev(series, length: length, bias: bias);
  }

  static Series<PriceData> sma(
    Series<PriceData> series, {
    int lookBack = 20,
  }) {
    _validateArg('SMA (Simple Moving Average)', lookBack, 1);

    return calcSMA(series, lookBack: lookBack);
  }

  /// Moving average used in RSI. It is the exponentially weighted moving average with alpha = 1 / length.
  /// recommended warmup periods = 150.
  static Series<PriceData> rma(
    Series<PriceData> series, {
    int lookBack = 14,
  }) {
    _validateArg('RMA (Relative Moving Average)', lookBack, 1);

    return calcRMA(series, lookBack: lookBack);
  }

  static Series<PriceData> ema(
    Series<PriceData> series, {
    int lookBack = 20,
  }) {
    _validateArg('EMA (Exponential Moving Average)', lookBack, 1);

    return calcEMA(series, lookBack: lookBack);
  }

  static Series<PriceData> alma(
    Series<PriceData> series, {
    int lookBack = 9,
    double offset = 0.85,
    double sigma = 6,
  }) {
    _validateArg('ALMA (Arnaud Legoux Moving Average.)', lookBack, 1);

    return calcAlma(series, lookBack: lookBack, offset: offset, sigma: sigma);
  }

  static Series<PriceData> rsi(
    Series<PriceData> series, {
    int lookBack = 14,
  }) {
    _validateArg('RSI (Relative Strength Index)', lookBack, 2);

    return calcRSI(series, lookBack: lookBack);
  }

  static Series<TsiResult> tsi(
    Series<PriceData> series, {
    int lookBack = 25,
    int smoothLen = 13,
    int signalLen = 13,
  }) {
    _validateArg('TSI (True Strength Index)', lookBack, 1);
    _validateArg('TSI (True Strength Index)', smoothLen, 1);
    _validateArg('TSI (True Strength Index)', signalLen, 1);

    return calcTSI(
      series,
      lookBack: lookBack,
      smoothLen: smoothLen,
      signalLen: signalLen,
    );
  }

  static Series<PriceData> mfi(
    Series<({DateTime date, double value, double vol})> series, {
    int lookBack = 14,
  }) {
    _validateArg('MFI (Money Flow Index)', lookBack, 1);

    return calcMFI(series, lookBack: lookBack);
  }

  static Series<PriceData> wpr(
    QuoteSeries series, {
    int lookBack = 14,
  }) {
    _validateArg('WPR (Williams Percent Range)', lookBack, 1);

    return calcWPR(series, lookBack: lookBack);
  }

  static Series<BBResult> bb(
    Series<PriceData> series, {
    int lookBack = 20,
    double multi = 2.0,
  }) {
    _validateArg('BB (Bollinger Bands)', lookBack, 1);

    if (multi < 1.0) {
      throw ArgumentError(
        'Bollinger Bands must be greater than 1',
      );
    }

    return calcBB(series, lookBack: lookBack, multi: multi);
  }

  static Series<PriceData> bbw(
    Series<PriceData> series, {
    int lookBack = 5,
    int multi = 4,
  }) {
    _validateArg('BBW (Bollinger Bands Width)', lookBack, 1);
    _validateArg('BBW (Bollinger Bands Width)', multi, 1);

    return calcBBW(series, lookBack: lookBack, multi: multi);
  }

  static Series<PriceData> wma(
    Series<PriceData> series, {
    int lookBack = 15,
  }) {
    _validateArg('WMA (Weighted Moving Average)', lookBack, 1);

    return calcWMA(series, lookBack: lookBack);
  }

  static Series<PriceData> linReg(
    Series<PriceData> series, {
    int lookBack = 1,
  }) {
    _validateArg('Linear Regression', lookBack, 1);

    return calcLinReg(series, lookBack: lookBack);
  }

  static Series<PriceData> tci(
    Series<PriceData> series,
  ) {
    _validateArg('TCI', 9, 1);

    return calcTCI(series);
  }

  static Series<PriceData> willy(
    Series<PriceData> series,
  ) {
    _validateArg('WILLY', 9, 1);

    return calcWilly(series);
  }

  static Series<PhxResult> phx(
    QuoteSeries series,
  ) {
    return calcPhx(series);
  }
}
