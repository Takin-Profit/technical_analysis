/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'linreg.dart';
import 'mfi.dart';
import 'rsi.dart';
import 'series.dart';
import 'sma.dart';
import 'tci.dart';
import 'tsi.dart';
import 'willy.dart';

typedef PhxResult = ({DateTime date, double fast, double slow, double lsma});

/// Requires 150 bar warmup due to the use of the TSI.
Stream<PhxResult> calcPhx(QuoteSeries series) {
  final phx = getPHX();

  return series.map((quote) {
    final q = quote.toDoublePrecis();

    return phx(q);
  });
}

PhxResult Function(
  ({
    DateTime date,
    double open,
    double high,
    double low,
    double close,
    double volume
  }),
) getPHX() {
  final getRsi = getRSI(len: 3);
  final getMfi = getMFI(len: 3);
  final getTsi = getTSI(len: 9, smoothLen: 6);
  final getSma = getSMA(len: 6);
  final getWilly = getWILLY(len: 6);
  final getTci = getTCI(len: 9);
  final getLinReg = getLINREG(len: 32);

  return (({
        DateTime date,
        double open,
        double high,
        double low,
        double close,
        double volume
      }) quote) {
    final hlc3 = (quote.high + quote.low + quote.close) / 3;
    final tci = getTci(hlc3);
    final mfi = getMfi(value: hlc3, vol: quote.volume);
    final willy = getWilly(hlc3);
    final rsi = getRsi(hlc3);
    final tsi = getTsi(quote.open).value / 100;

    final csi = (rsi + (tsi * 50 + 50)) / 2;
    final phx = (tci + csi + mfi + willy) / 4;
    final trad = (tci + mfi + rsi) / 3;
    final fast = (phx + trad) / 2;

    final slow = getSma(fast);
    final lsma = getLinReg(fast);

    return (date: quote.date, fast: fast, slow: slow, lsma: lsma);
  };
}

({
  DateTime date,
  double hlc3,
  double tci,
  double mfi,
  double willy,
  double rsi,
  double tsi,
  double csi,
  double phx,
  double trad,
  double fast,
  double slow,
  double lsma,
})
        Function(({DateTime date, double open, double high, double low, double close, double volume}) quote)
    getPhxTest() {
  final getRsi = getRSI(len: 3);
  final getMfi = getMFI(len: 3);
  final getTsi = getTSI(len: 9, smoothLen: 6);
  final getSma = getSMA(len: 6);
  final getWilly = getWILLY(len: 6);
  final getTci = getTCI(len: 9);
  final getLinReg = getLINREG(len: 32);

  return (({
        DateTime date,
        double open,
        double high,
        double low,
        double close,
        double volume
      }) quote) {
    final hlc3 = (quote.high + quote.low + quote.close) / 3;
    final tci = getTci(hlc3);
    final mfi = getMfi(value: hlc3, vol: quote.volume);
    final willy = getWilly(hlc3);
    final rsi = getRsi(hlc3);
    final tsi = getTsi(quote.open).value / 100;

    final csi = (rsi + (tsi * 50 + 50)) / 2;
    final phx = (tci + csi + mfi + willy) / 4;
    final trad = (tci + mfi + rsi) / 3;
    final fast = (phx + trad) / 2;

    final slow = getSma(fast);
    final lsma = getLinReg(fast);

    return (
      hlc3: hlc3,
      tci: tci,
      mfi: mfi,
      willy: willy,
      rsi: rsi,
      tsi: tsi,
      csi: csi,
      phx: phx,
      trad: trad,
      fast: fast,
      date: quote.date,
      slow: slow,
      lsma: lsma
    );
  };
}

Stream<
    ({
      DateTime date,
      double hlc3,
      double tci,
      double mfi,
      double willy,
      double rsi,
      double tsi,
      double csi,
      double phx,
      double trad,
      double fast,
      double slow,
      double lsma,
    })> calcPhxTest(QuoteSeries series) {
  final phx = getPhxTest();

  return series.map((quote) {
    final q = quote.toDoublePrecis();

    return phx(q);
  });
}
