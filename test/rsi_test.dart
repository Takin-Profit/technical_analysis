// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// ignore_for_file: prefer-correct-identifier-length

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
  group('TA.rsi tests', () {
    test('RSI Result should have correct length', () async {
      final res = TA.rsi(quotes.closes);
      final _ = await quotes.close();
      final result = await res.toList();
      expect(result.length, 502);
    });
    test('Should return the correct number of results without nan', () async {
      final res = TA.rsi(quotes.closes);
      final _ = await quotes.close();
      final resultList = await res.toList();
      final result = resultList.where((q) => !q.value.isNaN).toList();
      expect(result.length, 489);
    });

    test('Should return the correct calculation values', () async {
      final res = TA.rsi(quotes.closes);
      final _ = await quotes.close();
      final resultList = await res.toList();
      final result = resultList.toList();

      expect(result[12].value, isNaN, reason: 'should be NaN');
      expect(
        result[14].value.toPrecision(4),
        closeTo(62.0541, 0.5),
        reason: 'should be 62.0541',
      );
      expect(
        result[249].value.toPrecision(4),
        70.9368,
        reason: 'should equal 70.9368',
      );

      expect(
        result[501].value.toPrecision(4),
        42.0773,
        reason: 'should equal 42.0773',
      );
    });
    test('Should throw exception with too small lookBack < 2', () async {
      final _ = await quotes.close();

      expect(
        () => TA.rsi(quotes.closes, lookBack: 1),
        throwsArgumentError,
        reason: 'should throw',
      );
      expect(
        () => TA.rsi(quotes.closes, lookBack: 0),
        throwsArgumentError,
        reason: 'should throw',
      );
    });
  });
}
