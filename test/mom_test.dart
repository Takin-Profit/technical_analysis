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
 * https://docs.google.com/spreadsheets/d/1SpgDEXj961o-8m7zhfEebKArWi2uVshBVnLKtDx52G8/edit?usp=sharing
 * data exported from tradingvew.
 */

Future<void> main() async {
  final data = await getBtcMom();
  late QuoteSeries quotes;
  setUp(
    () => {
      quotes = QuotesSeries.fromIterable(data).getOrElse(
        (l) => emptySeries,
      ),
    },
  );
  group('TA.mom tests', () {
    test('HMA Result should have correct length', () async {
      final res = TA.kama(quotes.closes);
      final _ = await quotes.close();
      final result = await res.toList();
      expect(result.length, 800);
    });
    test('Should return the correct number of results without nan', () async {
      final res = TA.mom(quotes.closes);
      final _ = await quotes.close();
      final resultList = await res.toList();
      final result = resultList.where((q) => !q.value.isNaN).toList();
      expect(result.length, 780);
    });

    test('Should return the correct calculation results', () async {
      final res = TA.mom(quotes.closes);
      final _ = await quotes.close();
      final results = await res.toList();

      expect(
        results[28].value.toPrecision(1),
        1682.1,
        reason: 'should be 1682.1',
      );

      expect(
        results[100].value.toPrecision(1),
        1789.3,
        reason: 'should be 1789.3',
      );

      expect(
        results[218].value.toPrecision(1),
        4884.4,
        reason: 'should be 4884.4',
      );
      expect(
        results[457].value.toPrecision(1),
        -5082.8,
        reason: 'should be -5082.8',
      );
      expect(
        results[756].value.toPrecision(1),
        -9419.7,
        reason: 'should be -9419.7',
      );
    });
  });
}
