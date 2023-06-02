/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'package:statistics/statistics.dart';
import 'package:technical_analysis/technical_analysis.dart';
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
      final result = QuotesSeries.fromIterable(quotes);

      expect(result.isError, false);
      final first = await result.value?.first;
      expect(first?.date, equals(quotes.first.date));
      expect(first?.open, equals(quotes.first.open));
      expect(first?.high, equals(quotes.first.high));
      expect(first?.low, equals(quotes.first.low));
      expect(first?.close, equals(quotes.first.close));
      expect(first?.volume, equals(quotes.first.volume));
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
      final result = QuotesSeries.fromIterable(quotes);

      expect(result.isError, true);
      expect(
        result.firstError.description,
        startsWith('Quotes with duplicate dates found ${date.toString()}'),
      );
    });
    test('createSeries respects maxSize parameter', () async {
      final quotes = List.generate(
        20,
        (index) => (
          date: DateTime.now().add(Duration(days: index)),
          open: Decimal.fromInt(1),
          high: Decimal.fromInt(2),
          low: Decimal.fromInt(1),
          close: Decimal.fromInt(2),
          volume: Decimal.fromInt(100),
        ),
      );
      final maxSize = 10;
      final result = QuotesSeries.fromIterable(quotes, maxSize: maxSize);

      expect(result.isError, false);

      final _ = await result.value?.close();

      final len = await result.value?.length;

      expect(len, equals(maxSize));
    });

    test('createSeries calls onListen and onCancel callbacks', () {
      var onListenCalled = false;
      var onCancelCalled = false;
      void onListen() {
        onListenCalled = true;
      }

      void onCancel() {
        onCancelCalled = true;
      }

      final quotes = [
        (
          date: DateTime.now(),
          open: Decimal.fromInt(1),
          high: Decimal.fromInt(2),
          low: Decimal.fromInt(1),
          close: Decimal.fromInt(2),
          volume: Decimal.fromInt(100),
        ),
      ];
      final result = QuotesSeries.fromIterable(
        quotes,
        onListen: onListen,
        onCancel: onCancel,
      );

      expect(result.isError, false);

      final subscription = result.value?.listen((_) {});
      expect(onListenCalled, equals(true));
      subscription?.cancel();
      expect(onCancelCalled, equals(true));
    });
  });

  group('toTimeFrame function', () {});
}
