/*
 * Copyright (c) 2023. 
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'package:technical_analysis/src/bbwp.dart';

import 'alma.dart';
import 'bb.dart';
import 'bbw.dart';
import 'dema.dart';
import 'ema.dart';
import 'er.dart';
import 'hma.dart';
import 'kama.dart';
import 'linreg.dart';
import 'mfi.dart';
import 'mom.dart';
import 'percent_rank.dart';
import 'phx.dart';
import 'rma.dart';
import 'rsi.dart';
import 'series.dart';
import 'sma.dart';
import 'smma.dart';
import 'std_dev.dart';
import 'swma.dart';
import 'tci.dart';
import 'tema.dart';
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
    int len = 2,
  }) {
    _validateArg('Percent Rank', len, 2);

    return calcPercentRank(series, len: len);
  }

  static Series<PriceData> stdDev(
    Series<PriceData> series, {
    int length = 1,
    StDevOf bias = StDevOf.population,
  }) {
    if (length < 1) {
      throw ArgumentError(
        'Length must be greater than 0 to calculate the standard deviation',
      );
    }

    return calcStdDev(series, len: length, bias: bias);
  }

  static Series<PriceData> sma(
    Series<PriceData> series, {
    int lookBack = 20,
  }) {
    _validateArg('SMA (Simple Moving Average)', lookBack, 1);

    return calcSMA(series, len: lookBack);
  }

  static Series<PriceData> dema(
    Series<PriceData> series, {
    int len = 20,
  }) {
    _validateArg('Dema (Simple Moving Average)', len, 1);

    return calcDema(series, len: len);
  }

  /// Moving average used in RSI. It is the exponentially weighted moving average with alpha = 1 / length.
  /// recommended warmup periods = 150.
  static Series<PriceData> rma(
    Series<PriceData> series, {
    int lookBack = 14,
  }) {
    _validateArg('RMA (Relative Moving Average)', lookBack, 1);

    return calcRMA(series, len: lookBack);
  }

  static Series<PriceData> kama(
    Series<PriceData> series, {
    int len = 10,
  }) {
    _validateArg('Kama (Kaufman Moving Average Adaptive )', len, 1);

    return calcKama(series, len: len);
  }

  static Series<PriceData> ema(
    Series<PriceData> series, {
    int len = 20,
  }) {
    _validateArg('EMA (Exponential Moving Average)', len, 1);

    return calcEMA(series, len: len);
  }

  static Series<PriceData> alma(
    Series<PriceData> series, {
    int len = 9,
    double offset = 0.85,
    double sigma = 6,
  }) {
    _validateArg('ALMA (Arnaud Legoux Moving Average.)', len, 1);

    return calcAlma(series, len: len, offset: offset, sigma: sigma);
  }

  static Series<PriceData> smma(
    Series<PriceData> series, {
    int len = 20,
  }) {
    _validateArg('SMMA (Smoothed Moving Average)', len, 1);

    return calcSmma(series, len: len);
  }

  static Series<PriceData> swma(
    Series<PriceData> series,
  ) {
    return calcSwma(series);
  }

  static Series<PriceData> tema(
    Series<PriceData> series, {
    int len = 20,
  }) {
    _validateArg('Tema (Triple Smoothed Moving Average)', len, 1);

    return calcTema(series, len: len);
  }

  static Series<PriceData> er(
    Series<PriceData> series, {
    int len = 10,
  }) {
    _validateArg('ER (Efficiency Ratio)', len, 1);

    return calcEr(series, len: len);
  }

  static Series<PriceData> mom(
    Series<PriceData> series, {
    int len = 20,
  }) {
    _validateArg('Momentum', len, 1);

    return calcMom(series, len: len);
  }

  static Series<PriceData> rsi(
    Series<PriceData> series, {
    int len = 14,
  }) {
    _validateArg('RSI (Relative Strength Index)', len, 2);

    return calcRSI(series, len: len);
  }

  static Series<TsiResult> tsi(
    Series<PriceData> series, {
    int len = 25,
    int smoothLen = 13,
    int signalLen = 13,
  }) {
    _validateArg('TSI (True Strength Index)', len, 1);
    _validateArg('TSI (True Strength Index)', smoothLen, 1);
    _validateArg('TSI (True Strength Index)', signalLen, 1);

    return calcTSI(
      series,
      len: len,
      smoothLen: smoothLen,
      signalLen: signalLen,
    );
  }

  static Series<PriceData> mfi(
    Series<({DateTime date, double value, double vol})> series, {
    int len = 14,
  }) {
    _validateArg('MFI (Money Flow Index)', len, 1);

    return calcMFI(series, len: len);
  }

  static Series<PriceData> wpr(
    QuoteSeries series, {
    int len = 14,
  }) {
    _validateArg('WPR (Williams Percent Range)', len, 1);

    return calcWPR(series, len: len);
  }

  static Series<BBResult> bb(
    Series<PriceData> series, {
    int len = 20,
    int multi = 2,
  }) {
    _validateArg('BB (Bollinger Bands)', len, 1);

    if (multi < 1.0) {
      throw ArgumentError(
        'Bollinger Bands must be greater than 1',
      );
    }

    return calcBB(series, len: len, multi: multi);
  }

  static Series<PriceData> bbw(
    Series<PriceData> series, {
    int len = 5,
    int multi = 4,
  }) {
    _validateArg('BBW (Bollinger Bands Width)', len, 1);
    _validateArg('BBW (Bollinger Bands Width)', multi, 1);

    return calcBBW(series, len: len, multi: multi);
  }

  static Series<PriceData> bbwp(
    Series<PriceData> series, {
    int len = 13,
  }) {
    _validateArg('BBWP (Bollinger Bands Width Percentile)', len, 2);

    return calcBbwp(series, len: len);
  }

  static Series<PriceData> wma(
    Series<PriceData> series, {
    int len = 15,
  }) {
    _validateArg('WMA (Weighted Moving Average)', len, 1);

    return calcWMA(series, len: len);
  }

  static Series<PriceData> hma(
    Series<PriceData> series, {
    int len = 16,
  }) {
    _validateArg('HMA (Weighted Moving Average)', len, 1);

    return calcHma(series, len: len);
  }

  static Series<PriceData> linReg(
    Series<PriceData> series, {
    int len = 1,
  }) {
    _validateArg('Linear Regression', len, 1);

    return calcLinReg(series, len: len);
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
