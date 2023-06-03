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
 * https://docs.google.com/spreadsheets/d/1BXN6hLp82zW2v2TvZhgG6mG4ei_O46fthgW09Y3d5XE/edit?usp=sharing
 */

Future<void> main() async {
  final data = await getBtcKama();
  late QuoteSeries quotes;
  setUp(
    () => {
      quotes = QuotesSeries.fromIterable(data).getOrElse(
        (l) => emptySeries,
      ),
    },
  );
  group('TA.kama tests', () {
    test('HMA Result should have correct length', () async {
      final res = TA.kama(quotes.closes);
      final _ = await quotes.close();
      final result = await res.toList();
      expect(result.length, 800);
    });
    test('Should return the correct number of results without nan', () async {
      final res = TA.kama(quotes.closes);
      final _ = await quotes.close();
      final resultList = await res.toList();
      final result = resultList.where((q) => !q.value.isNaN).toList();
      expect(result.length, 789);
    });

    test('Should return the correct calculation results', () async {
      final res = TA.kama(quotes.closes);
      final _ = await quotes.close();
      final results = await res.toList();

      expect(
        results[28].value.toPrecision(5),
        40082.93864,
        reason: 'should be 40082.93864',
      );

      expect(
        results[100].value.toPrecision(5),
        38890.52285,
        reason: 'should be 235.6972',
      );

      expect(
        results[218].value.toPrecision(5),
        53797.05852,
        reason: 'should be 53797.05852',
      );
      expect(
        results[457].value.toPrecision(5),
        26967.0988,
        reason: 'should be 26967.0988',
      );
      expect(
        results[756].value.toPrecision(5),
        47478.49872,
        reason: 'should be 47478.49872',
      );
    });
  });
}
