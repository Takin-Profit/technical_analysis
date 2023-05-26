// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:statistics/statistics.dart';

import 'circular_buf.dart';
import 'series.dart';
import 'types.dart';

sealed class Util {
  static DateTime get minDate => DateTime.fromMicrosecondsSinceEpoch(0)
      .subtract(const Duration(days: 100000000));

  static DateTime get maxDate => DateTime.fromMicrosecondsSinceEpoch(0)
      .add(const Duration(days: 100000000));

  static Series<PriceData> change(
    Series<PriceData> series, {
    int length = 1,
  }) async* {
    final buffer = CircularBuf(size: length + 1);

    await for (final current in series) {
      buffer.put(current.value);

      if (buffer.isFull) {
        yield (date: current.date, value: current.value - buffer.first);
      } else {
        yield (date: current.date, value: double.nan);
      }
    }
  }

  static Series<PriceData> highest(
    Series<PriceData> series, {
    int length = 1,
  }) async* {
    final buffer = CircularBuf(size: length);

    await for (final current in series) {
      buffer.put(current.value);

      if (buffer.isFull) {
        final maxVal = buffer.values.max;
        yield (date: current.date, value: maxVal);
      } else {
        yield (date: current.date, value: double.nan);
      }
    }
  }

  static Series<PriceData> lowest(
    Series<PriceData> series, {
    int length = 1,
  }) async* {
    final buffer = CircularBuf(size: length);

    await for (final current in series) {
      buffer.put(current.value);

      if (buffer.isFull) {
        final lowestValue = buffer.values.min;

        yield (date: current.date, value: lowestValue);
      } else {
        yield (date: current.date, value: double.nan);
      }
    }
  }

  /// Replaces NaN values with zeros (or given value) in a series.
  /// https://www.tradingview.com/pine-script-reference/v5/#fun_nz
  static double nz(double value, {double replaceWith = 0}) {
    return value.isNaN ? replaceWith : value;
  }

  static double sma(List<PriceData> data) =>
      data.map((priceData) => priceData.value).average;
}

extension DoubleExt on double {
  double toPrecision(int precision) {
    return double.parse(toStringAsFixed(precision));
  }
}

extension DateTimeRounding on DateTime {
  DateTime roundDown(Duration duration) {
    if (duration == Duration.zero) {
      return this;
    } else {
      final intervalTicks = duration.inMicroseconds;
      final dateTimeTicks = this.microsecondsSinceEpoch;

      return DateTime.fromMicrosecondsSinceEpoch(
        dateTimeTicks - (dateTimeTicks % intervalTicks),
      );
    }
  }
}

extension Decimals on Decimal {
  static Decimal get nan => Decimal.parse(
        double.nan.toString(),
      );
}

class SimpleLinearRegression {
  late double slope;
  late double intercept;

  SimpleLinearRegression(Iterable<double> x, Iterable<double> y) {
    if (x.length != y.length) {
      throw Exception('Input vectors should have the same length');
    }

    double xSum = 0, ySum = 0, xxSum = 0, xySum = 0;
    int count = 0;

    final xIter = x.iterator;
    final yIter = y.iterator;

    while (xIter.moveNext() && yIter.moveNext()) {
      xSum += xIter.current;
      ySum += yIter.current;
      xxSum += xIter.current * xIter.current;
      xySum += xIter.current * yIter.current;
      count++;
    }

    slope = (count * xySum - xSum * ySum) / (count * xxSum - xSum * xSum);
    intercept = (ySum - slope * xSum) / count;
  }

  double predict(double x) => slope * x + intercept;
}
