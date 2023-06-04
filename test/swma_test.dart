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
 * https://docs.google.com/spreadsheets/d/1Jkh4spBAsw7i7IWa5tJXcAfrzL4mI9872HnRXhdWGAg/edit?usp=sharing
 */

Future<void> main() async {
  final data = await getEthSwma();
  late QuoteSeries quotes;
  setUp(
    () => {
      quotes = QuotesSeries.fromIterable(data).getOrElse(
        (l) => emptySeries,
      ),
    },
  );
  group('TA.swma tests', () {
    test('Swma Result should have correct length', () async {
      final res = TA.swma(quotes.closes);
      final _ = await quotes.close();
      final result = await res.toList();
      expect(result.length, 600);
    });
    test('Should return the correct number of results without nan', () async {
      final res = TA.swma(quotes.closes);
      final _ = await quotes.close();
      final resultList = await res.toList();
      final result = resultList.whereNot((q) => q.value.isNaN).toList();
      expect(result.length, 597);
    });

    test('Should return the correct calculation results', () async {
      final res = TA.swma(quotes.closes);
      final _ = await quotes.close();
      final results = await res.toList();

      final result18 = results[18];
      final result19 = results[19];

      expect(
        result18.value.toPrecision(6),
        2952.113333,
        reason: 'should be 2952.113333',
      );
      expect(
        result19.value.toPrecision(6),
        2897.156667,
        reason: 'should be 2897.156667',
      );
      expect(
        results[100].value.toPrecision(6),
        3926.851667,
        reason: 'should be 3926.851667',
      );
      expect(
        results[501].value.toPrecision(6),
        1615.058333,
        reason: 'should be 1615.058333',
      );
    });
  });
}
