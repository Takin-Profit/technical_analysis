// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

sealed class Util {
  static DateTime get minDate => DateTime.fromMicrosecondsSinceEpoch(0)
      .subtract(Duration(days: 100000000));

  static DateTime get maxDate =>
      DateTime.fromMicrosecondsSinceEpoch(0).add(Duration(days: 100000000));
}

extension DoubleExt on double {
  double toPrecision(int precision) {
    return double.parse(toStringAsFixed(precision));
  }
}
