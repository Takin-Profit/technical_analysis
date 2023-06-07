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

Future<void> main() async {
  final data = await getAtrSlRma();
  final smaData = await getAtrSlSma();

  /*
 *
 * expected results.
 * https://docs.google.com/spreadsheets/d/1pNv37IY18LyaHxf9XmdFAOAIj_iByq7Q_jwGSAv5ce0/edit?usp=sharing
 * data exported from tradingview.com
 */
  group('TA.atrSl RMA tests', () {
    late QuoteSeries quotes;
    setUp(
      () => {
        quotes = QuotesSeries.fromIterable(data).getOrElse(
          (l) => emptySeries,
        ),
      },
    );
    test('ATRSL Result should have correct length', () async {
      final res = TA.atrSl(quotes);
      final _ = await quotes.close();
      final result = await res.toList();

      expect(result.length, 800);
    });
    test('Should return the correct number of results without nan', () async {
      final res = TA.atrSl(quotes);
      final _ = await quotes.close();
      final resultList = await res.toList();
      final result = resultList.whereNot((q) => q.shortSl.isNaN).toList();
      expect(result.length, 787);
    });

    test('Should return the correct SHORT stop loss with maType RMA', () async {
      final res = TA.atrSl(quotes);
      final _ = await quotes.close();
      final results = await res.toList();

      final result0 = results.first;
      final result6 = results[6];
      final result29 = results[29];
      final result249 = results[249];
      final result501 = results[501];

      expect(result0.shortSl.isNaN, true);
      expect(result6.shortSl.isNaN, true);
      // warmup period
      expect(
        result29.shortSl.toPrecision(5),
        closeTo(9.774366, 0.02),
        reason: 'should be 9.774366',
      );
      // warmup period
      expect(
        results[120].shortSl.toPrecision(5),
        closeTo(22.07725, 0.00002),
        reason: 'should be 22.07725',
      );
      expect(
        result249.shortSl.toPrecision(5),
        243.55780,
        reason: 'should be 243.55780',
      );
      expect(
        result501.shortSl.toPrecision(5),
        585.41605,
        reason: 'should be 585.41605',
      );

      expect(
        results[744].shortSl.toPrecision(5),
        140.30701,
        reason: 'should be 140.30701',
      );
    });
    test('Should return the correct LONG stop loss with maType RMA', () async {
      final res = TA.atrSl(quotes);
      final _ = await quotes.close();
      final results = await res.toList();

      final result0 = results.first;
      final result6 = results[6];
      final result29 = results[29];
      final result249 = results[249];
      final result501 = results[501];

      expect(result0.longSl.isNaN, true);
      expect(result6.longSl.isNaN, true);
      // warmup period
      expect(
        result29.longSl.toPrecision(5),
        closeTo(6.87553, 0.02),
        reason: 'should be 6.87553',
      );
      // warmup period
      expect(
        results[120].longSl.toPrecision(5),
        closeTo(13.58122, 0.00002),
        reason: 'should be 13.58122',
      );
      expect(
        result249.longSl.toPrecision(5),
        100.44220,
        reason: 'should be 100.44220',
      );
      expect(
        result501.longSl.toPrecision(5),
        352.31395,
        reason: 'should be 352.31395',
      );

      expect(
        results[744].longSl.toPrecision(5),
        77.27299,
        reason: 'should be 77.27299',
      );
    });

    /*
 *
 * expected results.
 * https://docs.google.com/spreadsheets/d/1c-CDMm-vKh1M18LDtNvfXYjlYCMV6lI8tdfl-exMi_k/edit?usp=sharing
 * data exported from tradingview.com
 */
    group('Ta.atrSl SMA tests', () {
      late QuoteSeries quotes;
      setUp(
        () => {
          quotes = QuotesSeries.fromIterable(smaData).getOrElse(
            (l) => emptySeries,
          ),
        },
      );
      test(
        'Should return the correct SHORT stop loss with maType SMA',
        () async {
          final res = TA.atrSl(
            quotes,
            maType: AtrSlMaType.sma,
          );
          final _ = await quotes.close();
          final results = await res.toList();

          final result0 = results.first;
          final result6 = results[6];
          final result29 = results[29];
          final result249 = results[249];
          final result501 = results[501];

          expect(result0.shortSl.isNaN, true);
          expect(result6.shortSl.isNaN, true);
          // warmup period
          expect(
            result29.shortSl.toPrecision(5),
            closeTo(9.86079, 0.04),
            reason: 'should be 9.86079',
          );
          // warmup period
          expect(
            results[120].shortSl.toPrecision(5),
            closeTo(22.72193, 0.00002),
            reason: 'should be 22.72193',
          );
          expect(
            result249.shortSl.toPrecision(5),
            236.50711,
            reason: 'should be 236.50711',
          );
          expect(
            result501.shortSl.toPrecision(5),
            585.58214,
            reason: 'should be 585.58214',
          );

          expect(
            results[744].shortSl.toPrecision(5),
            144.35536,
            reason: 'should be 144.35536',
          );
        },
      );
      test(
        'Should return the correct LONG stop loss with maType SMA',
        () async {
          final res = TA.atrSl(
            quotes,
            maType: AtrSlMaType.sma,
          );
          final _ = await quotes.close();
          final results = await res.toList();

          final result0 = results.first;
          final result6 = results[6];
          final result29 = results[29];
          final result249 = results[249];
          final result501 = results[501];

          expect(result0.longSl.isNaN, true);
          expect(result6.longSl.isNaN, true);
          // warmup period
          expect(
            result29.longSl.toPrecision(5),
            closeTo(5.98522, 0.8),
            reason: 'should be 5.98522',
          );
          // warmup period
          expect(
            results[120].longSl.toPrecision(5),
            closeTo(12.93654, 0.00002),
            reason: 'should be 12.93654',
          );
          expect(
            result249.longSl.toPrecision(5),
            107.49289,
            reason: 'should be 107.49289',
          );
          expect(
            result501.longSl.toPrecision(5),
            352.14786,
            reason: 'should be 352.14786',
          );

          expect(
            results[744].longSl.toPrecision(5),
            73.22464,
            reason: 'should be 73.22464',
          );
        },
      );
    });
  });
}
