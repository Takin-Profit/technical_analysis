/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

// ignore_for_file: prefer-correct-identifier-length

import 'package:collection/collection.dart';
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
  final data = await getBtcAtrSl();
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
      final res = TA.atrSl(quotes);
      final _ = await quotes.close();
      final result = await res.toList();

      expect(result.length, 1000);
    });
    test('Should return the correct number of results without nan', () async {
      final res = TA.atrSl(quotes);
      final _ = await quotes.close();
      final resultList = await res.toList();
      final result = resultList.whereNot((q) => q.shortSl.isNaN).toList();
      expect(result.length, 994);
    });

    test('Should return the correct short stop loss with maType RMA', () async {
      final res = TA.atrSl(quotes);
      final _ = await quotes.close();
      final results = await res.toList();

      final result0 = results.first;
      final result6 = results[6];
      final result29 = results[29];
      final result249 = results[249];
      final result501 = results[501];

      for (int i = 0; i < results.length; i++) {
        print('$i = ${results[i]}');
      }

      expect(result0.shortSl.isNaN, true);
      expect(result6.shortSl.isNaN, false);
      // warmup period
      expect(
        result29.shortSl.toPrecision(5),
        30501.05984,
        reason: '30501.05984',
      );
      // warmup period
      expect(
        results[120].shortSl.toPrecision(5),
        30684.72417,
        reason: 'should be 30684.72417',
      );
      expect(
        result249.shortSl.toPrecision(5),
        29298.15774,
        reason: 'should be 29298.15774',
      );
      expect(
        result501.shortSl.toPrecision(5),
        29564.37024,
        reason: 'should be 29564.37024',
      );

      expect(
        results[744].shortSl.toPrecision(5),
        27847.30258,
        reason: 'should be 27847.30258',
      );
    });
  });
}
