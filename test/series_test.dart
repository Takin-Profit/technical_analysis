/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'package:decimal/decimal.dart';
import 'package:technical_indicators/technical_indicators.dart';
import 'package:test/test.dart';

Future<void> main() async {
  group('Series tests', () {
    test('createSeries returns a QuoteSeries for valid input', () async {
      final quotes = [
        (
          date: DateTime.now().subtract(Duration(days: 2)),
          open: Decimal.fromInt(1),
          high: Decimal.fromInt(2),
          low: Decimal.fromInt(1),
          close: Decimal.fromInt(2),
          volume: Decimal.fromInt(100)
        ),
        (
          date: DateTime.now().subtract(Duration(days: 1)),
          open: Decimal.fromInt(2),
          high: Decimal.fromInt(3),
          low: Decimal.fromInt(2),
          close: Decimal.fromInt(3),
          volume: Decimal.fromInt(200)
        ),
      ];
      final result = createSeries(quotes);

      expect(result.isRight(), equals(true));
      result.fold((l) => null, (r) async {
        final first = await r.first;
        expect(first.date, equals(quotes.first.date));
        expect(first.open, equals(quotes.first.open));
        expect(first.high, equals(quotes.first.high));
        expect(first.low, equals(quotes.first.low));
        expect(first.close, equals(quotes.first.close));
        expect(first.volume, equals(quotes.first.volume));
      });
    });

    test('createSeries returns an error for duplicate dates', () {
      final date = DateTime.now();
      final quotes = [
        (
          date: date,
          open: Decimal.fromInt(1),
          high: Decimal.fromInt(2),
          low: Decimal.fromInt(1),
          close: Decimal.fromInt(2),
          volume: Decimal.fromInt(100)
        ),
        (
          date: date,
          open: Decimal.fromInt(2),
          high: Decimal.fromInt(3),
          low: Decimal.fromInt(2),
          close: Decimal.fromInt(3),
          volume: Decimal.fromInt(200)
        ),
      ];
      final result = createSeries(quotes);

      expect(result.isLeft(), equals(true));
      expect(
        result.swap().getOrElse((r) => ""),
        startsWith('Quotes with duplicate dates found ${date.toString()}'),
      );
    });
  });
}
