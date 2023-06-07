// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'ema.dart';
import 'quotes.dart';
import 'rma.dart';
import 'series.dart';
import 'sma.dart';
import 'tr.dart';
import 'types.dart';
import 'wma.dart';

typedef AtrSlResult = ({DateTime date, double longSl, double shortSl});

/// https://www.tradingview.com/script/LgjsidVh-ATR-Stop-Loss-Finder/
Series<AtrSlResult> calcAtrSl(
  Series<Quote> series, {
  int len = 14,
  AtrSlMaType maType = AtrSlMaType.rma,
  double multi = 1.5,
}) {
  final atrSl = getAtrSl(len: len, maType: maType, multi: multi);

  return series.map(
    (data) {
      final result = atrSl(data.hlc);

      return (
        date: data.date,
        longSl: result.longSl,
        shortSl: result.shortSl,
      );
    },
  );
}

TaFunc _getMaType(int len, AtrSlMaType maType) {
  return switch (maType) {
    (AtrSlMaType.sma) => getSMA(len: len),
    (AtrSlMaType.rma) => getRMA(len: len),
    (AtrSlMaType.wma) => getWma(len: len),
    (AtrSlMaType.ema) => getEma(len: len),
  };
}

({double longSl, double shortSl}) Function(HLC) getAtrSl({
  int len = 14,
  AtrSlMaType maType = AtrSlMaType.rma,
  double multi = 1.5,
}) {
  final shortMa = _getMaType(len, maType);
  final longMa = _getMaType(len, maType);
  final tr = getTr();

  return (HLC data) {
    final trueRange = tr(data);

    return (
      longSl: data.low - longMa(trueRange) * multi,
      shortSl: shortMa(trueRange) * multi + data.high
    );
  };
}
