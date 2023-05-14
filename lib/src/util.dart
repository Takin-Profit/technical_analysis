// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'circular_buffer.dart';
import 'series.dart';
import 'types.dart';

sealed class Util {
  static DateTime get minDate => DateTime.fromMicrosecondsSinceEpoch(0)
      .subtract(Duration(days: 100000000));

  static DateTime get maxDate =>
      DateTime.fromMicrosecondsSinceEpoch(0).add(Duration(days: 100000000));

  static Series<double> change(Series<PriceDataDouble> series,
      {int length = 1}) async* {
    CircularBuffer<PriceDataDouble> buffer =
        CircularBuffer<PriceDataDouble>(length + 1);

    await for (PriceDataDouble current in series) {
      buffer.add(current);
      if (buffer.isFilled) {
        yield current.value - buffer.first.value;
      } else {
        yield double.nan;
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
