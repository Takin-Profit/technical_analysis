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
 * https://docs.google.com/spreadsheets/d/1N1QmE53TOTb4ejipyg3O5rZpoSBErOx84eE7y_qaSnE/edit?usp=sharing
 */

Future<void> main() async {
  final data = await getEthKama();
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
      expect(result.length, 600);
    });
    test('Should return the correct number of results without nan', () async {
      final res = TA.kama(quotes.closes);
      final _ = await quotes.close();
      final resultList = await res.toList();
      final result = resultList.where((q) => !q.value.isNaN).toList();
      expect(result.length, 590);
    });

    test('Should return the correct calculation results', () async {
      final res = TA.kama(quotes.closes);
      final _ = await quotes.close();
      final results = await res.toList();

      expect(
        results[218].value.toPrecision(6),
        closeTo(3213.655685, .00001),
        reason: 'should be 3213.655685',
      );
      expect(
        results[457].value.toPrecision(6),
        1255.504734,
        reason: 'should be 1255.504734',
      );
      expect(
        results[598].value.toPrecision(6),
        1924.649009,
        reason: 'should be 1924.649009',
      );
    });
  });
}
