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
 * https://docs.google.com/spreadsheets/d/1T14VAhzM14Yqf4sjE7UEcl1yJUyS27TRLPf0Bg-n3BY/edit?usp=sharing
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
  group('TA.alma tests', () {
    test('Ema Result should have correct length', () async {
      final res = TA.alma(quotes.closes, len: 10);
      final _ = await quotes.close();
      final result = await res.toList();
      expect(result.length, 502);
    });
    test('Should return the correct number of results without nan', () async {
      final res = TA.alma(quotes.closes, len: 10);
      final _ = await quotes.close();
      final resultList = await res.toList();
      final result = resultList.where((q) => !q.value.isNaN).toList();
      expect(result.length, 493);
    });

    test('Should return the correct calculation results', () async {
      final res = TA.alma(quotes.closes, len: 10);
      final _ = await quotes.close();
      final results = await res.toList();

      final result0 = results.first;
      final result8 = results[8];
      final result9 = results[9];
      final result249 = results[249];
      final result501 = results[501];

      expect(result0.value.isNaN, true);
      expect(result8.value.isNaN, true);
      expect(
        result9.value.toPrecision(4),
        214.1839,
        reason: 'should be 214.1839',
      );

      expect(
        results[24].value.toPrecision(4),
        216.0619,
        reason: 'should be 216.0619',
      );
      expect(
        result249.value.toPrecision(4),
        257.5787,
        reason: 'should be 257.5787',
      );
      expect(
        result501.value.toPrecision(4),
        242.1871,
        reason: 'should be 242.1871',
      );
    });
  });
}
