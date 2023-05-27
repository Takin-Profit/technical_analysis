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
  final data = await getDefault();
  late QuoteSeries quotes;
  setUp(
    () => {
      quotes = QuotesSeries.fromIterable(data).getOrElse(
        (l) => emptySeries,
      ),
    },
  );
  group('TA.ema tests', () {
    test('Ema Result should have correct length', () async {
      final res = TA.ema(quotes.closes);
      final _ = await quotes.close();
      final result = await res.toList();
      expect(result.length, 502);
    });
    test('Should return the correct number of results without nan', () async {
      final res = TA.ema(quotes.closes);
      final _ = await quotes.close();
      final resultList = await res.toList();
      final result = resultList.where((q) => !q.value.isNaN).toList();
      expect(result.length, 483);
    });

    test('Should return the correct calculation results', () async {
      final res = TA.ema(quotes.closes);
      final _ = await quotes.close();
      final results = await res.toList();

      final result0 = results.first;
      final result6 = results[6];
      final result29 = results[29];
      final result249 = results[249];
      final result501 = results[501];

      expect(result0.value.isNaN, true);
      expect(result6.value.isNaN, true);
      expect(
        result29.value.toPrecision(4),
        216.6228,
        reason: 'should be 216.6228',
      );

      expect(
        results[30].value.toPrecision(4),
        217.1292,
        reason: 'should be 217.1292',
      );
      expect(
        result249.value.toPrecision(4),
        255.3873,
        reason: 'should be 255.3873',
      );
      expect(
        result501.value.toPrecision(4),
        249.3519,
        reason: 'should be 249.3519',
      );
    });
  });
}
