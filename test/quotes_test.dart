// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:statistics/statistics.dart';
import 'package:technical_analysis/src/series.dart';
// ignore_for_file: prefer-correct-identifier-length

import 'package:technical_analysis/technical_analysis.dart';
import 'package:test/test.dart';

void main() {
  final dt = DateTime.parse('2015-05-05');
  final o = Decimal.parse('222222222222222');
  final h = Decimal.parse('444444444444444');
  final l = Decimal.parse('111111111111111');
  final c = Decimal.parse('333333333333333');
  final v = Decimal.parse('555555555555555');

  final d2 = 2.toDecimal().compactedPrecision;
  final d3 = 3.toDecimal().compactedPrecision;

  final _hl2 = (h + l) / d2;
  final _hlc3 = (h + l + c) / d3;
  final _oc2 = (o + c) / d2;
  final _ohl3 = (o + h + l) / d3;
  final _ohl4 = (o + h + l + c) / 4.toDecimal().compactedPrecision;

  final hl2 = _hl2.toDecimal();
  final hlc3 = _hlc3.toDecimal();
  final oc2 = _oc2.toDecimal();
  final ohl3 = _ohl3.toDecimal();
  final ohl4 = _ohl4.toDecimal();

  final Quote q = (date: dt, open: o, high: h, low: l, close: c, volume: v);

  group('Quote tests', () {
    test('Converting to double should return correct results', () {
      expect(
        q.toPriceDataDouble(candlePart: CandlePart.open).value.toPrecision(10),
        o.toDouble().toPrecision(10),
        reason: 'should return correct open price',
      );
      expect(
        q.toPriceDataDouble(candlePart: CandlePart.high).value.toPrecision(10),
        h.toDouble().toPrecision(10),
        reason: 'should return correct high price',
      );
      expect(
        q.toPriceDataDouble(candlePart: CandlePart.low).value.toPrecision(10),
        l.toDouble().toPrecision(10),
        reason: 'should return correct low price',
      );
      expect(
        q.toPriceDataDouble(candlePart: CandlePart.close).value.toPrecision(10),
        c.toDouble().toPrecision(10),
        reason: 'should return correct close price',
      );
      expect(
        q
            .toPriceDataDouble(candlePart: CandlePart.volume)
            .value
            .toPrecision(10),
        v.toDouble().toPrecision(10),
        reason: 'should return correct volume price',
      );
      expect(
        q.toPriceDataDouble(candlePart: CandlePart.hl2).value.toPrecision(10),
        hl2.toDouble().toPrecision(10),
        reason: 'should return correct hl2 price',
      );
      expect(
        q.toPriceDataDouble(candlePart: CandlePart.hlc3).value.toPrecision(10),
        hlc3.toDouble().toPrecision(10),
        reason: 'should return correct hlc3 price',
      );
      expect(
        q.toPriceDataDouble(candlePart: CandlePart.oc2).value.toPrecision(10),
        oc2.toDouble().toPrecision(10),
        reason: 'should return correct oc2 price',
      );
      expect(
        q.toPriceDataDouble(candlePart: CandlePart.ohl3).value.toPrecision(10),
        ohl3.toDouble().toPrecision(10),
        reason: 'should return correct ohl3 price',
      );
      expect(
        q.toPriceDataDouble(candlePart: CandlePart.ohlc4).value.toPrecision(10),
        ohl4.toDouble().toPrecision(10),
        reason: 'should return correct ohlc4 price',
      );
    });

    test(
      'createQuote should return error when low price is greater than open, high, or close price',
      () {
        final result = Quotes.createQuote(
          date: DateTime.now(),
          open: Decimal.fromInt(100),
          high: Decimal.fromInt(200),
          low: Decimal.fromInt(300),
          close: Decimal.fromInt(150),
          volume: Decimal.fromInt(5000),
        );

        expect(result.isError, true);
        expect(
          result.firstError.description,
          contains(
            'low: 300.0, cannot be greater than open: 100.0, high: 200.0, or close: 150.0 price',
          ),
        );
      },
    );

    test(
      'createQuote should return error when high price is less than open, low, or close price',
      () {
        final result = Quotes.createQuote(
          date: DateTime.now(),
          open: Decimal.fromInt(100),
          high: Decimal.fromInt(50),
          low: Decimal.fromInt(80),
          close: Decimal.fromInt(90),
          volume: Decimal.fromInt(5000),
        );

        expect(result.isError, true);
        expect(
          result.firstError.description,
          contains(
            'low: 80.0, cannot be greater than open: 100.0, high: 50.0, or close: 90.0 price',
          ),
        );
      },
    );

    test('createQuote should return error when OLHCV values are negative', () {
      final result = Quotes.createQuote(
        date: DateTime.now(),
        open: Decimal.fromInt(-100),
        high: Decimal.fromInt(200),
        low: Decimal.fromInt(80),
        close: Decimal.fromInt(150),
        volume: Decimal.fromInt(-5000),
      );

      expect(result.isError, true);
      expect(
        result.firstError.description,
        contains(
          'low: 80.0, cannot be greater than open: -100.0, high: 200.0, or close: 150.0 price',
        ),
      );
    });

    test('createQuote should return error when date is in the future', () {
      final result = Quotes.createQuote(
        date: DateTime.now().add(Duration(days: 1)),
        open: Decimal.fromInt(100),
        high: Decimal.fromInt(200),
        low: Decimal.fromInt(80),
        close: Decimal.fromInt(150),
        volume: Decimal.fromInt(5000),
      );

      expect(result.isError, true);
      expect(
        result.firstError.description,
        contains(
          'occurs in the future and cannot be added to the series',
        ),
      );
    });

    test('createQuote should return valid Quote when data is valid', () {
      final result = Quotes.createQuote(
        date: DateTime.now(),
        open: Decimal.fromInt(100),
        high: Decimal.fromInt(200),
        low: Decimal.fromInt(80),
        close: Decimal.fromInt(150),
        volume: Decimal.fromInt(5000),
      );

      expect(result.isError, false);
      expect(result.valueGet, isNotNull);
    });
    test(
      'createQuote should return error when open price is negative',
      () {
        final result = Quotes.createQuote(
          date: DateTime.now(),
          open: Decimal.fromInt(-100),
          high: Decimal.fromInt(200),
          low: Decimal.fromInt(80),
          close: Decimal.fromInt(150),
          volume: Decimal.fromInt(5000),
        );

        expect(result.isError, true);
        expect(
          result.firstError.description,
          contains(
            'low: 80.0, cannot be greater than open: -100.0, high: 200.0, or close: 150.0 price',
          ),
        );
      },
    );

    test(
      'createQuote should return error when high price is negative',
      () {
        final result = Quotes.createQuote(
          date: DateTime.now(),
          open: Decimal.fromInt(100),
          high: Decimal.fromInt(-200),
          low: Decimal.fromInt(80),
          close: Decimal.fromInt(150),
          volume: Decimal.fromInt(5000),
        );

        expect(result.isError, true);
        expect(
          result.firstError.description,
          contains(
            'low: 80.0, cannot be greater than open: 100.0, high: -200.0, or close: 150.0 price',
          ),
        );
      },
    );

    test(
      'createQuote should return error when low price is negative',
      () {
        final result = Quotes.createQuote(
          date: DateTime.now(),
          open: Decimal.fromInt(100),
          high: Decimal.fromInt(200),
          low: Decimal.fromInt(-80),
          close: Decimal.fromInt(150),
          volume: Decimal.fromInt(5000),
        );

        expect(result.isError, true);
        expect(
          result.firstError.description,
          contains(
            'Invalid Data found low = -80.0 OLHCV values cannot be negative',
          ),
        );
      },
    );

    test(
      'createQuote should return error when close price is negative',
      () {
        final result = Quotes.createQuote(
          date: DateTime.now(),
          open: Decimal.fromInt(100),
          high: Decimal.fromInt(200),
          low: Decimal.fromInt(80),
          close: Decimal.fromInt(-150),
          volume: Decimal.fromInt(5000),
        );

        expect(result.isError, true);
        expect(
          result.firstError.description,
          contains(
            'low: 80.0, cannot be greater than open: 100.0, high: 200.0, or close: -150.0 price',
          ),
        );
      },
    );

    test(
      'createQuote should return error when volume is negative',
      () {
        final result = Quotes.createQuote(
          date: DateTime.now(),
          open: Decimal.fromInt(100),
          high: Decimal.fromInt(200),
          low: Decimal.fromInt(80),
          close: Decimal.fromInt(150),
          volume: Decimal.fromInt(-5000),
        );

        expect(result.isError, true);
        expect(
          result.firstError.description,
          contains(
            'Invalid Data found volume = -5000.0 OLHCV values cannot be negative',
          ),
        );
      },
    );

    test('createQuote should return valid Quote when all values are zero', () {
      final dec = Decimal.fromInt(0);
      //
      // ignore_for_file: no-equal-arguments
      final result = Quotes.createQuote(
        date: DateTime.now(),
        open: dec,
        high: dec,
        low: dec,
        close: dec,
        volume: dec,
      );

      expect(result.isError, false);
      expect(result.valueGet, isNotNull);
    });
  });
}
