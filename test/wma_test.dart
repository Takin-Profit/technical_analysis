/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */
import 'package:technical_analysis/technical_analysis.dart';
import 'package:test/test.dart';

import 'data/test_data.dart';

// ignore_for_file: prefer-correct-identifier-length,double-literal-format
/*
 * expected results.
 * https://docs.google.com/spreadsheets/d/1n3-bYh1V0JMStMBIJKE6CSJCLMMEP19tD7vGkRrtq6I/edit?usp=sharing
 */

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
  group('TA.wma tests', () {
    test('WMA Result should have correct length', () async {
      final res = TA.wma(quotes.closes, len: 20);
      final _ = await quotes.close();
      final result = await res.toList();
      expect(result.length, 502);
    });
    test('Should return the correct number of results without nan', () async {
      final res = TA.wma(quotes.closes, len: 20);
      final _ = await quotes.close();
      final resultList = await res.toList();
      final result = resultList.where((q) => !q.value.isNaN).toList();
      expect(result.length, 483);
    });

    test('Should return the correct calculation results', () async {
      final res = TA.wma(quotes.closes, len: 20);
      final _ = await quotes.close();
      final results = await res.toList();

      final result149 = results[149];
      final result501 = results[501];

      expect(
        result149.value.toPrecision(4),
        235.5253,
        reason: 'should be 235.5253 on date = ${result149.date}',
      );

      expect(
        result501.value.toPrecision(4),
        246.5110,
        reason: 'should be 246.5110',
      );
    });
  });
}
