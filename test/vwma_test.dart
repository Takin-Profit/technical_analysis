// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// ignore_for_file: prefer-correct-identifier-length,double-literal-format

import 'package:technical_analysis/technical_analysis.dart';
import 'package:test/test.dart';

import 'data/test_data.dart';

/*
 * expected results.
 * https://docs.google.com/spreadsheets/d/1FhE3RHgoEguLQgZN48trNTmL1i-7aifQitNO7tBxmOs/edit?usp=sharing
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
  group('TA.vwma tests', () {
    test('Vwma Result should have correct length', () async {
      final res = TA.vwma(quotes.closeWithVol, len: 10);
      final _ = await quotes.close();
      final result = await res.toList();
      expect(result.length, 502);
    });
    test('Should return the correct number of results without nan', () async {
      final res = TA.vwma(quotes.closeWithVol, len: 10);
      final _ = await quotes.close();
      final resultList = await res.toList();
      final result = resultList.where((q) => !q.value.isNaN).toList();
      expect(result.length, 493);
    });

    test('Should return the correct calculation results', () async {
      final res = TA.vwma(quotes.closeWithVol, len: 10);
      final _ = await quotes.close();
      final results = await res.toList();

      final result8 = results[8];
      final result9 = results[9];
      final result24 = results[24];
      final result99 = results[99];
      final result249 = results[249];
      final result501 = results[501];

      expect(result8.value.isNaN, true);
      expect(
        result9.value.toPrecision(6),
        213.981942,
      );
      expect(
        result24.value.toPrecision(6),
        215.899211,
      );
      expect(
        result99.value.toPrecision(6),
        226.302760,
      );
      expect(
        result249.value.toPrecision(6),
        257.053654,
      );
      expect(
        result501.value.toPrecision(6),
        242.101548,
      );
    });
  });
}
