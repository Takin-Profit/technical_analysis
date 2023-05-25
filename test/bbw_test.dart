/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

// ignore_for_file: prefer-correct-identifier-length,double-literal-format

import 'package:technical_analysis/technical_analysis.dart';
import 'package:test/test.dart';

import 'data/test_data.dart';

/*
 *
 * expected results.
 * https://docs.google.com/spreadsheets/d/1wRUEeAw5MeG50_zmDDt4CsFnqrsfxk5OHtjQtVSvavs/edit?usp=sharing
 * data exported from tradingview.
 */

Future<void> main() async {
  final data = await getEthBbw();
  late QuoteSeries quotes;
  setUp(
    () => {
      quotes = QuotesSeries.fromIterable(data).getOrElse(
        (l) => emptySeries,
      ),
    },
  );
  group('TA.percentRank tests', () {
    test('should have correct length', () async {
      final res = TA.bbw(quotes.closes);
      final _ = await quotes.close();
      final result = await res.toList();
      expect(result.length, 630);
    });
    test('Should return the correct number of results without nan', () async {
      final res = TA.bbw(quotes.closes);
      ;
      final _ = await quotes.close();
      final resultList = await res.toList();
      final result = resultList.where((q) => !q.value.isNaN).toList();
      expect(result.length, 626);
    });

    test('Should return the correct calculation results', () async {
      final res = TA.bbw(quotes.closes);
      final _ = await quotes.close();
      final results = await res.toList();

      final result6 = results[6];
      final result29 = results[29];
      final result247 = results[247];
      final result400 = results[400];
      final result501 = results[501];
      final result628 = results[628];

      for (var i = 0; i < results.length; i++) {
        print('$i , ${results[i].value}');
      }
      expect(
        result6.value.toPrecision(7),
        0.5883643,
        reason: 'should be 0.5883643',
      );
      expect(
        result29.value.toPrecision(8),
        0.23415884,
        reason: 'should be 0.23415884',
      );

      expect(
        result247.value.toPrecision(6),
        0.192808,
        reason: 'should be 0.192808',
      );

      expect(
        result400.value.toPrecision(4),
        0.1403,
        reason: 'should be 0.1403',
      );
      expect(
        result501.value.toPrecision(4),
        0.2590,
        reason: 'should be 0.2590',
      );
      expect(
        result628.value.toPrecision(7),
        0.0452276,
        reason: 'should be 0.0452276',
      );
    });
  });
}
