// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
// ignore_for_file: prefer-correct-identifier-length,double-literal-format

import 'package:technical_indicators/technical_indicators.dart';
import 'package:test/test.dart';

import 'data/test_data.dart';

Future<void> main() async {
  final data = await getDefault();
  late QuoteSeries quotes;
  setUp(
    () => {
      quotes = QuotesSeries.fromIterable(data).getOrElse(
        (l) => emptySeries,
      ),
    },
  );
  group('TA.change tests', () {
    test('should return correct result for 10 bars ago', () async {
      final res = TA.change(quotes.closes, length: 10);
      final _ = await quotes.close();
      final result = await res.toList();
      expect(
        result.last.value.toPrecision(5),
        -8.87000,
        reason: 'should be -8.87000',
      );
    });
    test('should return correct result for 50 bars ago', () async {
      final res = TA.change(quotes.closes, length: 50);
      final _ = await quotes.close();
      final result = await res.toList();
      expect(
        result.last.value.toPrecision(5),
        -28.36000,
        reason: 'should be -28.36000',
      );
    });
    test('should return correct result for 316 bars ago', () async {
      final res = TA.change(quotes.closes, length: 316);
      final _ = await quotes.close();
      final result = await res.toList();
      expect(
        result.last.value.toPrecision(5),
        5.68000,
        reason: 'should be 5.68000',
      );
    });
    test('should should throw exception for invalid length', () {
      expect(
        () => TA.change(quotes.closes, length: 0),
        throwsArgumentError,
        reason: 'should throw argumentError',
      );
    });
  });
  group('TA.highest tests', () {
    test('Highest function returns correct results', () async {
      final inputSeries = Stream.fromIterable([
        (date: DateTime(2023, 1, 1), value: 1.0),
        (date: DateTime(2023, 1, 2), value: 2.0),
        (date: DateTime(2023, 1, 3), value: 3.0),
        (date: DateTime(2023, 1, 4), value: 2.0),
        (date: DateTime(2023, 1, 5), value: 1.0),
        (date: DateTime(2023, 1, 6), value: 4.0),
        (date: DateTime(2023, 1, 7), value: 3.0),
      ]);

      final results = await TA.highest(inputSeries, length: 3).toList();

      final expected = [
        (date: DateTime(2023, 1, 1), value: double.nan),
        (date: DateTime(2023, 1, 2), value: double.nan),
        (date: DateTime(2023, 1, 3), value: 3.0),
        (date: DateTime(2023, 1, 4), value: 3.0),
        (date: DateTime(2023, 1, 5), value: 3.0),
        (date: DateTime(2023, 1, 6), value: 4.0),
        (date: DateTime(2023, 1, 7), value: 4.0),
      ];

      expect(results.first.date, equals(expected.first.date));
    });

    test('Highest function handles empty series', () async {
      final inputSeries = Stream<PriceDataDouble>.empty();

      final results = await TA.highest(inputSeries, length: 3).toList();

      final expected = [];

      expect(results, equals(expected));
    });

    test('Highest function handles series shorter than length', () async {
      final inputSeries = Stream.fromIterable([
        (date: DateTime(2023, 1, 1), value: 1.0),
        (date: DateTime(2023, 1, 2), value: 2.0),
      ]);

      final results = await TA.highest(inputSeries, length: 3).toList();

      final expected = [
        (date: DateTime(2023, 1, 1), value: double.nan),
        (date: DateTime(2023, 1, 2), value: double.nan),
      ];

      expect(results.last.date, equals(expected.last.date));
    });
  });
  group('TA.lowest tests', () {
    test('lowest function', () async {
      final testData = Stream.fromIterable([
        (date: DateTime(2022, 1, 1), value: 10.0),
        (date: DateTime(2022, 1, 2), value: 11.0),
        (date: DateTime(2022, 1, 3), value: 12.0),
        (date: DateTime(2022, 1, 4), value: 13.0),
        (date: DateTime(2022, 1, 5), value: 9.0),
        (date: DateTime(2022, 1, 6), value: 8.0),
        (date: DateTime(2022, 1, 7), value: 14.0),
      ]);
      final results = TA.lowest(testData, length: 3);
      final result = await results.toList();

      expect(result.first.value, isNaN);
      expect(result[1].value, isNaN);
      expect(result[2].value, 10.0, reason: 'should be 10.0');
      expect(result[3].value, 11.0, reason: 'should be 11.0');
      expect(result[4].value, 9.0, reason: 'should be 9.0');
      expect(result[5].value, 8.0, reason: 'should be 8.0');
      expect(result[6].value, 8.0, reason: 'should be 8.0');
    });
    test('lowest function returns correct values', () async {
      final testData = Stream.fromIterable([
        (date: DateTime(2022, 1, 1), value: 10.0),
        (date: DateTime(2022, 1, 2), value: 11.0),
        (date: DateTime(2022, 1, 3), value: 12.0),
        (date: DateTime(2022, 1, 4), value: 13.0),
        (date: DateTime(2022, 1, 5), value: 9.0),
        (date: DateTime(2022, 1, 6), value: 8.0),
        (date: DateTime(2022, 1, 7), value: 14.0),
      ]);

      final result = await TA.lowest(testData, length: 3).toList();

      expect(result.first.value.isNaN, true);
      expect(result[1].value.isNaN, true);
      expect(result[2].value, 10.0);
      expect(result[3].value, 11.0);
      expect(result[4].value, 9.0);
      expect(result[5].value, 8.0);
      expect(result[6].value, 8.0);
    });

    test('lowest function with larger lookBack period', () async {
      final testData = Stream.fromIterable([
        (date: DateTime(2022, 1, 1), value: 10.0),
        (date: DateTime(2022, 1, 2), value: 11.0),
        (date: DateTime(2022, 1, 3), value: 12.0),
        (date: DateTime(2022, 1, 4), value: 13.0),
        (date: DateTime(2022, 1, 5), value: 9.0),
        (date: DateTime(2022, 1, 6), value: 8.0),
        (date: DateTime(2022, 1, 7), value: 14.0),
      ]);

      final result = await TA.lowest(testData, length: 5).toList();

      expect(result.first.value.isNaN, true);
      expect(result[1].value.isNaN, true);
      expect(result[2].value.isNaN, true);
      expect(result[3].value.isNaN, true);
      expect(result[4].value, 9.0);
      expect(result[5].value, 8.0);
      expect(result[6].value, 8.0);
    });
    test('lowest function with all equal values', () async {
      final testData = Stream.fromIterable([
        (date: DateTime(2022, 1, 1), value: 10.0),
        (date: DateTime(2022, 1, 2), value: 10.0),
        (date: DateTime(2022, 1, 3), value: 10.0),
        (date: DateTime(2022, 1, 4), value: 10.0),
        (date: DateTime(2022, 1, 5), value: 10.0),
      ]);

      final result = await TA.lowest(testData, length: 3).toList();

      expect(result.first.value.isNaN, true);
      expect(result[1].value.isNaN, true);
      expect(result[2].value, 10.0);
      expect(result[3].value, 10.0);
      expect(result[4].value, 10.0);
    });
    test('lowest function with negative values', () async {
      final testData = Stream.fromIterable([
        (date: DateTime(2022, 1, 1), value: -10.0),
        (date: DateTime(2022, 1, 2), value: -9.0),
        (date: DateTime(2022, 1, 3), value: -8.0),
        (date: DateTime(2022, 1, 4), value: -7.0),
        (date: DateTime(2022, 1, 5), value: -6.0),
      ]);

      final result = await TA.lowest(testData, length: 3).toList();

      expect(result.first.value.isNaN, true);
      expect(result[1].value.isNaN, true);
      expect(result[2].value, -10.0);
      expect(result[3].value, -9.0);
      expect(result[4].value, -8.0);
    });
  });
}
