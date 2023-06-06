/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

// ignore_for_file: prefer-correct-identifier-length

import 'package:technical_analysis/technical_analysis.dart';
import 'package:test/test.dart';

import 'data/test_data.dart';

/*
 *
 * expected results.
 * https://docs.google.com/spreadsheets/d/1eW-NygnESwoCc1BGKXpxQsAFzLsMGaUnVH6168KoigE/edit?usp=sharing
 * data exported from tradingview.com
 */

Future<void> main() async {
  final data = await getGoldAtr();
  late QuoteSeries quotes;
  setUp(
    () => {
      quotes = QuotesSeries.fromIterable(data).getOrElse(
        (l) => emptySeries,
      ),
    },
  );
  group('TA.atrSl tests', () {
    test('ATRSL Result should have correct length', () async {
      final res = TA.atr(quotes);
      final _ = await quotes.close();
      final result = await res.toList();
      expect(result.length, 750);
    });
    test('Should return the correct number of results without nan', () async {
      final res = TA.atr(quotes);
      final _ = await quotes.close();
      final resultList = await res.toList();
      final result = resultList.where((q) => !q.value.isNaN).toList();
      expect(result.length, 737);
    });

    test('Should return the correct calculation results', () async {
      final res = TA.atr(quotes);
      final _ = await quotes.close();
      final results = await res.toList();

      final result0 = results.first;
      final result6 = results[6];
      final result29 = results[29];
      final result249 = results[249];
      final result501 = results[501];

      expect(result0.value.isNaN, true);
      expect(result6.value.isNaN, true);
      // warmup period
      expect(
        result29.value.toPrecision(6),
        closeTo(33.534839, 0.54),
        reason: 'should be 33.534839',
      );
      // warmup period
      expect(
        results[120].value.toPrecision(6),
        closeTo(
          28.173596,
          0.001,
        ),
        reason: 'should be 28.173596',
      );
      expect(
        result249.value.toPrecision(6),
        26.339388,
        reason: 'should be 26.339388',
      );
      expect(
        result501.value.toPrecision(6),
        23.935408,
        reason: 'should be 23.935408',
      );

      expect(
        results[744].value.toPrecision(6),
        27.673529,
        reason: 'should be 27.673529',
      );
    });
  });
}
