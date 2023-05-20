// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// ignore_for_file: prefer-correct-identifier-length

import 'package:technical_analysis/technical_analysis.dart';
import 'package:test/test.dart';

import 'data/test_data.dart';

/*
* expected results are found directly in data/eth_rma.csv file.
* Exported directly from tradingview.
 */
Future<void> main() async {
  final data = await getEthRMA();
  late QuoteSeries quotes;
  setUp(
    () => {
      quotes = QuotesSeries.fromIterable(data).getOrElse(
        (l) => emptySeries,
      ),
    },
  );
  group('TA.rma tests', () {
    test('Sma Result should have correct length', () async {
      final res = TA.rma(quotes.closes);
      final _ = await quotes.close();
      final result = await res.toList();
      expect(result.length, 500);
    });
    test('quotes and results should have matching dates', () async {
      final res = TA.rma(quotes.closes);
      final _ = await quotes.close();
      final results = await res.toList();
      expect(results[210].date, data[210].date, reason: 'Dates should match');
      expect(results[23].date, data[23].date, reason: 'Dates should match');
      expect(results[98].date, data[98].date, reason: 'Dates should match');
      expect(results[240].date, data[240].date, reason: 'Dates should match');
      expect(results[199].date, data[199].date, reason: 'Dates should match');
      expect(results[387].date, data[387].date, reason: 'Dates should match');
    });

    test('should return correct Values for eth_rma.csv', () async {
      final res = TA.rma(quotes.closes);
      final _ = await quotes.close();
      final results = await res.toList();

      expect(
        results[200].value.toPrecision(4),
        closeTo(1297.1244, 0.01),
        reason: 'should be close to 1297.1244',
      );

      expect(
        results[345].value.toPrecision(4),
        1280.8835,
        reason: 'should be close to 1280.8835',
      );

      expect(
        results[80].value.toPrecision(4),
        closeTo(2827.6204, 0.9),
        reason: 'should be close to 2827.6204',
      );

      expect(
        results[154].value.toPrecision(4),
        closeTo(2493.5138, 0.02),
        reason: 'should be close to 2493.5138',
      );

      expect(
        results[271].value.toPrecision(4),
        closeTo(1642.0148, 0.001),
        reason: 'should be close to 1280.8835',
      );

      expect(
        results[452].value.toPrecision(4),
        closeTo(1568.4215, 0.001),
        reason: 'should be close to 1568.4215',
      );

      expect(
        results[488].value.toPrecision(4),
        closeTo(1879.2303, 0.001),
        reason: 'should be close to 1879.2303',
      );
    });
  });
}
