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
 * https://docs.google.com/spreadsheets/d/1cn3vwgBhhNqkHDgg7JNSCBWFSaSPtZjxub1WQTvwA-Y/edit?usp=sharing
 * data exported directly from tradingview.
 */

Future<void> main() async {
  final data = await getGoldLinReg();
  late QuoteSeries quotes;
  setUp(
    () => {
      quotes = QuotesSeries.fromIterable(data).getOrElse(
        (l) => emptySeries,
      ),
    },
  );
  group('TA.linreg tests', () {
    test('WMA Result should have correct length', () async {
      final res = TA.linReg(quotes.closes, len: 20);
      final _ = await quotes.close();
      final result = await res.toList();
      expect(result.length, 900);
    });
    test('Should return the correct number of results without nan', () async {
      final res = TA.linReg(quotes.closes, len: 20);
      final _ = await quotes.close();
      final resultList = await res.toList();
      final result = resultList.where((q) => !q.value.isNaN).toList();
      expect(result.length, 881);
    });

    test('Should return the correct calculation results', () async {
      final res = TA.linReg(quotes.closes, len: 20);
      final _ = await quotes.close();
      final results = await res.toList();

      final result249 = results[249];
      final result482 = results[482];

      expect(
        result249.value.toPrecision(6),
        1935.009186,
        reason: 'should be 1935.009186',
      );

      expect(
        result482.value.toPrecision(6),
        1784.800743,
        reason: 'should be 1784.800743',
      );
    });

    test(
      'Should return the correct calculation results at high precision',
      () async {
        final res = TA.linReg(quotes.closes, len: 20);
        final _ = await quotes.close();
        final results = await res.toList();

        final result55 = results[55];
        final result734 = results[734];

        expect(
          result55.value.toPrecision(9),
          1466.118385714,
          reason: 'should be 1466.118385714',
        );

        expect(
          result734.value.toPrecision(9),
          1720.119642857,
          reason: 'should be 1720.119642857',
        );
      },
    );
  });
}
