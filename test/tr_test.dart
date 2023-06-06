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
 * https://docs.google.com/spreadsheets/d/1JPLgPpKkOfr8hGDOzlO3sVGI4GsP-4wJ6pWMEPkbXxo/edit?usp=sharing
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
  group('TA.tr tests', () {
    test('True Range Result should have correct length', () async {
      final res = TA.tr(quotes);
      final _ = await quotes.close();
      final result = await res.toList();
      expect(result.length, 502);
    });
    test('Should not return any nan results when handleNa = true', () async {
      final res = TA.tr(quotes);
      final _ = await quotes.close();
      final resultList = await res.toList();
      final result = resultList.where((q) => !q.value.isNaN).toList();
      expect(result.length, 502);
    });
    test('First result should be nan when handleNa set to false', () async {
      final res = TA.tr(quotes, handleNa: false);
      final _ = await quotes.close();
      final resultList = await res.toList();
      final result = resultList.where((q) => !q.value.isNaN).toList();
      expect(result.length, 501);
    });

    test('Should return the correct calculation results', () async {
      final res = TA.tr(quotes);
      final _ = await quotes.close();
      final results = await res.toList();

      expect(
        results[1].value.toPrecision(8),
        1.42,
        reason: 'should be 1.42',
      );

      expect(
        results[12].value.toPrecision(8),
        1.32,
        reason: 'should be 1.32',
      );
    });
  });
}
