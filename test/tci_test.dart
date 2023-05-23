// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// ignore_for_file: prefer-correct-identifier-length

import 'package:technical_analysis/technical_analysis.dart';
import 'package:test/test.dart';

import 'data/test_data.dart';

/*
 *
 * expected results.
 * https://docs.google.com/spreadsheets/d/1lg7Fbz-986auSClakX9RS-Y-zrcDZYP8gfYSHQhHP4E/edit?usp=sharing
 */

Future<void> main() async {
  final data = await getGoldTci();
  late QuoteSeries quotes;
  setUp(
    () => {
      quotes = QuotesSeries.fromIterable(data).getOrElse(
        (l) => emptySeries,
      ),
    },
  );
  group('TA.tci tests', () {
    test('TCI Result should have correct length', () async {
      final res = TA.tci(quotes.hlc3);
      final _ = await quotes.close();
      final result = await res.toList();
      expect(result.length, 900);
    });
    test('Should return the correct number of results without nan', () async {
      final res = TA.tci(quotes.hlc3);
      final _ = await quotes.close();
      final resultList = await res.toList();
      final result = resultList.where((q) => !q.value.isNaN).toList();
      expect(result.length, 892);
    });

    test('Should return the correct calculation results', () async {
      final res = TA.tci(quotes.hlc3);
      final _ = await quotes.close();
      final results = await res.toList();

      final result0 = results.first;
      final result6 = results[6];
      final result29 = results[29];
      final result249 = results[249];
      final result501 = results[501];
      final result614 = results[614];
      final result866 = results[866];

      expect(result0.value.isNaN, true);
      expect(result6.value.isNaN, true);
      expect(
        result29.value.toPrecision(6),
        closeTo(99.510543, 0.5),
        reason: 'should be 99.510543',
      );
      expect(
        result249.value.toPrecision(6),
        47.310191,
        reason: 'should be 47.310191',
      );
      expect(
        result501.value.toPrecision(6),
        19.429759,
        reason: 'should be 19.429759',
      );
      expect(
        result614.value.toPrecision(6),
        77.738827,
        reason: 'should be 77.738827',
      );
      expect(
        result866.value.toPrecision(6),
        30.642783,
        reason: 'should be 30.642783',
      );
    });
  });
}
