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
 * https://docs.google.com/spreadsheets/d/1vULEBa80HsutwepMzzLM340dWrKNcnAfwqYK0aduCw4/edit?usp=sharing
 */

Future<void> main() async {
  final data = await getDefault();
  late QuoteSeries quotes;
  setUp(
    () => {
      quotes = QuotesSeries.fromIterable(data).getOrElse(
        (l) => emptySeries,
      ),
    },
  );
  group('TA.tema tests', () {
    test('Tema Result should have correct length', () async {
      final res = TA.tema(quotes.closes);
      final _ = await quotes.close();
      final result = await res.toList();
      expect(result.length, 502);
    });
    test('Should return the correct number of results without nan', () async {
      final res = TA.tema(quotes.closes);
      final _ = await quotes.close();
      final resultList = await res.toList();
      final result = resultList.whereNot((q) => q.value.isNaN).toList();
      expect(result.length, 445);
    });

    test('Should return the correct calculation results', () async {
      final res = TA.tema(quotes.closes);
      final _ = await quotes.close();
      final results = await res.toList();

      final result18 = results[18];
      final result19 = results[19];

      expect(
        result18.value,
        isNaN,
        reason: 'should be nan',
      );
      expect(
        result19.value,
        isNaN,
        reason: 'should be nan',
      );
      expect(
        results[100].value.toPrecision(4),
        closeTo(228.4719, 0.01),
        reason: 'should be 228.4719',
      );
      expect(
        results[501].value.toPrecision(4),
        closeTo(238.0345, 0.8),
        reason: 'should be 1615.058333',
      );
    });
  });
}
