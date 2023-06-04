/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

// ignore_for_file: prefer-correct-identifier-length,double-literal-format

import 'package:collection/collection.dart';
import 'package:technical_analysis/technical_analysis.dart';
import 'package:test/test.dart';

import 'data/test_data.dart';

/*
 * expected results.
 * https://docs.google.com/spreadsheets/d/1x33gVMO4ZZdVmFwrIQoqR8u8iFARayk-XNoblY1jnic/edit?usp=sharing
 * data exported from tradingview.com
 */

Future<void> main() async {
  final data = await getEthBbwp();
  late QuoteSeries quotes;
  setUp(
    () => {
      quotes = QuotesSeries.fromIterable(data).getOrElse(
        (l) => emptySeries,
      ),
    },
  );
  group('TA.bbwp tests', () {
    test('BBWP Result should have correct length', () async {
      final res = TA.bbwp(quotes.closes);
      final _ = await quotes.close();
      final result = await res.toList();
      expect(result.length, 700);
    });
    test('Should return the correct number of results without nan', () async {
      final res = TA.bbwp(quotes.closes);
      final _ = await quotes.close();
      final resultList = await res.toList();
      final result = resultList.whereNot((q) => q.value.isNaN).toList();
      expect(result.length, 700);
    });

    test('Should return the correct calculation results', () async {
      final res = TA.bbwp(quotes.closes);
      final _ = await quotes.close();
      final results = await res.toList();

      final result18 = results[18];

      for (var i = 0; i < results.length; i++) {
        print('$i = ${results[i]}');
      }

      expect(
        result18.value.toPrecision(6),
        23.809524,
        reason: 'should be 23.809524',
      );
      expect(
        results[87].value.toPrecision(6),
        1.587302,
        reason: 'should be 1.587302',
      );
      expect(
        results[249].value.toPrecision(6),
        36.111111,
        reason: 'should be 36.111111',
      );
      expect(
        results[501].value.toPrecision(6),
        5.952381,
        reason: 'should be 5.952381',
      );
    });
  });
}
