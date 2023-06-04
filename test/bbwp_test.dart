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
      expect(result.length, 448);
    });

    test('Should return the correct calculation results', () async {
      final res = TA.bbwp(quotes.closes);
      final _ = await quotes.close();
      final results = await res.toList();

      final result18 = results[18];

      expect(
        result18.value.isNaN,
        true,
        reason: 'should be nan',
      );
      expect(
        results[87].value,
        isNaN,
        reason: 'should be nan',
      );
      // beginning of warmup phase
      expect(
        results[252].value.toPrecision(5),
        closeTo(72.61905, 2.4),
        reason: 'should be 72.61905',
      );
      // fully warmed.
      expect(
        results[501].value.toPrecision(6),
        5.952381,
        reason: 'should be 5.952381',
      );
      // fully warmed.
      expect(
        results[589].value.toPrecision(6),
        25.793651,
        reason: 'should be 25.793651',
      );
      // fully warmed
      expect(
        results[699].value.toPrecision(6),
        55.158730,
        reason: 'should be 55.158730',
      );
    });
  });
}
