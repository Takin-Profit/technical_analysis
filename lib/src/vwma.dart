// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'series.dart';
import 'sma.dart';
import 'types.dart';

Series<PriceData> calcVwma(
  Series<({DateTime date, double value, double vol})> series, {
  int len = 20,
}) {
  final vwma = getVwma(len: len);

  return series.map(
    (data) => (
      date: data.date,
      value: vwma(
        (
          value: data.value,
          vol: data.vol,
        ),
      ),
    ),
  );
}

double Function(({double value, double vol})) getVwma({
  int len = 20,
}) {
  final sma1 = getSMA(len: len);
  final sma2 = getSMA(len: len);

  return (({double value, double vol}) data) {
    return sma1(data.value * data.vol) / sma2(data.vol);
  };
}
