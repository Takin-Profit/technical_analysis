// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:decimal/decimal.dart';
import 'package:technical_indicators/src/series.dart';
// ignore_for_file: prefer-correct-identifier-length

import 'package:technical_indicators/technical_indicators.dart';
import 'package:test/test.dart';

Decimal _d(String s) => Decimal.parse(s);

void main() {
  final dt = DateTime.parse('2015-05-05');
  final o = Decimal.parse('222222222222222');
  final h = Decimal.parse('444444444444444');
  final l = Decimal.parse('111111111111111');
  final c = Decimal.parse('333333333333333');
  final v = Decimal.parse('555555555555555');

  final d2 = _d('2');
  final d3 = _d('3');

  final _hl2 = (h + l) / d2;
  final _hlc3 = (h + l + c) / d3;
  final _oc2 = (o + c) / d2;
  final _ohl3 = (o + h + l) / d3;
  final _ohl4 = (o + h + l + c) / _d('4');

  final hl2 = _hl2.toDecimal();
  final hlc3 = _hlc3.toDecimal();
  final oc2 = _oc2.toDecimal();
  final ohl3 = _ohl3.toDecimal();
  final ohl4 = _ohl4.toDecimal();

  final Quote q = (date: dt, open: o, high: h, low: l, close: c, volume: v);

  group('Quote tests', () {
    test('Converting to double should return correct results', () {
      final res = q.toPriceDataDouble(candlePart: CandlePart.open);

      expect(
        res.value.toPrecision(10),
        o.toDouble().toPrecision(10),
        reason: 'should return correct open price',
      );
    });
  });
}
