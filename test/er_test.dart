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
 * https://docs.google.com/spreadsheets/d/1XZBYAfBKpqNu_nylnlu0od2A0z526ds9YknBln1CCpk/edit?usp=sharing
 * data exported from tradingview.
 */

Future<void> main() async {
  final data = await getEthEr();
  late QuoteSeries quotes;
  setUp(
    () => {
      quotes = QuotesSeries.fromIterable(data).getOrElse(
        (l) => emptySeries,
      ),
    },
  );
  group('TA.er tests', () {
    test('Efficiency Ratio Result should have correct length', () async {
      final res = TA.er(quotes.closes, len: 5);
      final _ = await quotes.close();
      final result = await res.toList();
      expect(result.length, 600);
    });
    test('Should return the correct number of results without nan', () async {
      final res = TA.er(quotes.closes, len: 5);
      final _ = await quotes.close();
      final resultList = await res.toList();
      final result = resultList.where((q) => !q.value.isNaN).toList();
      expect(result.length, 595);
    });

    test('Should return the correct calculation results', () async {
      final res = TA.er(quotes.closes, len: 5);
      final _ = await quotes.close();
      final results = await res.toList();

      expect(
        results[10].value.toPrecision(7),
        12.5591680,
        reason: 'should be 12.5591680',
      );

      expect(
        results[92].value.toPrecision(6),
        19.972991,
        reason: 'should be 19.972991',
      );

      expect(
        results[313].value.toPrecision(5),
        81.92721,
        reason: 'should be 81.92721',
      );
      expect(
        results[438].value.toPrecision(5),
        53.67261,
        reason: 'should be 53.67261',
      );
    });
  });
}
