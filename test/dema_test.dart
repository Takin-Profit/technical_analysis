/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */
import 'package:collection/collection.dart';
import 'package:technical_analysis/technical_analysis.dart';
import 'package:test/test.dart';

import 'data/test_data.dart';

// ignore_for_file: prefer-correct-identifier-length,double-literal-format
/*
 * expected results.
 * https://docs.google.com/spreadsheets/d/122N433yTEEv3uIn2EkucAbO7IId3nddAqQl5JVYamaI/edit?usp=sharing
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
  group('TA.hma tests', () {
    test('HMA Result should have correct length', () async {
      final res = TA.dema(quotes.closes);
      final _ = await quotes.close();
      final result = await res.toList();
      expect(result.length, 502);
    });
    test('Should return the correct number of results without nan', () async {
      final res = TA.dema(quotes.closes);
      final _ = await quotes.close();
      final resultList = await res.toList();
      final result = resultList.whereNot((q) => q.value.isNaN).toList();
      expect(result.length, 464);
    });

    test('Should return the correct calculation results', () async {
      final res = TA.dema(quotes.closes);
      final _ = await quotes.close();
      final results = await res.toList();

      expect(
        results[249].value.toPrecision(4),
        258.4452,
        reason: 'should be 258.4452',
      );
      expect(
        results[501].value.toPrecision(4),
        241.1677,
        reason: 'should be 241.1677',
      );
    });
  });
}
