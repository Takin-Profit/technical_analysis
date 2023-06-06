// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'sma.dart';

double Function(({double value, double vol})) getVwma({
  int len = 20,
}) {
  final sma1 = getSMA(len: len);
  final sma2 = getSMA(len: len);

  return (({double value, double vol}) data) {
    return sma1(data.value * data.vol) / sma2(data.vol);
  };
}
