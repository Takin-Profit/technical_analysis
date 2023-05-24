// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:math' as math;

import 'package:decimal/decimal.dart';

import 'circular_buffer.dart';
import 'series.dart';
import 'types.dart';

sealed class Util {
  static DateTime get minDate => DateTime.fromMicrosecondsSinceEpoch(0)
      .subtract(const Duration(days: 100000000));

  static DateTime get maxDate => DateTime.fromMicrosecondsSinceEpoch(0)
      .add(const Duration(days: 100000000));

  static Series<PriceDataDouble> change(
    Series<PriceDataDouble> series, {
    int length = 1,
  }) async* {
    final buffer = CircularBuffer<PriceDataDouble>(length + 1);

    await for (final current in series) {
      buffer.add(current);
      if (buffer.isFilled) {
        yield (date: current.date, value: current.value - buffer.first.value);
      } else {
        yield (date: current.date, value: double.nan);
      }
    }
  }

  static Series<PriceDataDouble> highest(
    Series<PriceDataDouble> series, {
    int length = 1,
  }) async* {
    final buffer = CircularBuffer<PriceDataDouble>(length);

    await for (final current in series) {
      buffer.add(current);

      if (buffer.isFilled) {
        final maxVal = buffer.map((x) => x.value).reduce(math.max);
        yield (date: current.date, value: maxVal);
      } else {
        yield (date: current.date, value: double.nan);
      }
    }
  }

  static Series<PriceDataDouble> lowest(
    Series<PriceDataDouble> series, {
    int length = 1,
  }) async* {
    final buffer = CircularBuffer<PriceDataDouble>(length);

    await for (final current in series) {
      buffer.add(current);

      if (buffer.isFilled) {
        final lowestValue = buffer.map((e) => e.value).reduce(math.min);

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

  SimpleLinearRegression(List<double> x, List<double> y) {
    if (x.length != y.length) {
      throw Exception('Input vectors should have the same length');
    }

    double xSum = 0, ySum = 0, xxSum = 0, xySum = 0;
    for (int i = 0; i < x.length; i++) {
      xSum += x[i];
      ySum += y[i];
      xxSum += x[i] * x[i];
      xySum += x[i] * y[i];
    }

    slope = (x.length * xySum - xSum * ySum) / (x.length * xxSum - xSum * xSum);
    intercept = (ySum - slope * xSum) / x.length;
  }

  double predict(double x) => slope * x + intercept;
}
