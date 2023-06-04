/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

// ignore_for_file: prefer-correct-identifier-length

import 'package:technical_analysis/technical_analysis.dart';
import 'package:test/test.dart';

import 'data/test_data.dart';

/*
 *
 * expected results.
 * https://docs.google.com/spreadsheets/d/1N9QbNyhS8a8sndj2mBMdC_fSfzJ-gTiR0zhnpHUemdQ/edit?usp=sharing
 * data exported from tradingview.
 */

Future<void> main() async {
  final data = await getCrudePercentRank();
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
      final res = TA.percentRank(quotes.closes, len: 20);
      final _ = await quotes.close();
      final result = await res.toList();
      expect(result.length, 630);
    });
    test('Should return the correct number of results without nan', () async {
      final res = TA.percentRank(quotes.closes, len: 20);
      final _ = await quotes.close();
      final resultList = await res.toList();
      final result = resultList.where((q) => !q.value.isNaN).toList();
      expect(result.length, 610);
    });

    test('Should return the correct calculation results', () async {
      final res = TA.percentRank(quotes.closes, len: 20);
      final _ = await quotes.close();
      final results = await res.toList();

      final result6 = results[6];
      final result29 = results[29];
      final result247 = results[247];
      final result400 = results[400];
      final result501 = results[501];
      final result628 = results[628];

      expect(result6.value.isNaN, true);
      expect(
        result29.value,
        80,
        reason: 'should be 80',
      );

      expect(
        result247.value,
        0,
        reason: 'should be 0',
      );

      expect(
        result400.value,
        20,
        reason: 'should be 20',
      );
      expect(
        result501.value,
        50,
        reason: 'should be 50',
      );
      expect(
        result628.value,
        15,
        reason: 'should be 15',
      );
    });
  });
}
