/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */
import 'package:technical_analysis/technical_analysis.dart';
import 'package:test/test.dart';

import 'data/test_data.dart';

// ignore_for_file: prefer-correct-identifier-length,double-literal-format
/*
 * expected results.
 * https://docs.google.com/spreadsheets/d/1bG_dLbUHhW07FRFH58p2A9ZSF5P5QskahsfMmhCQKkE/edit?usp=sharing
 */

Future<void> main() async {
  final data = await getDefault();
  final data2 = await getBtcTr();
  group('TA.tr tests default', () {
    late QuoteSeries quotes;
    setUp(
      () => {
        quotes = QuotesSeries.fromIterable(data).getOrElse(
          (l) => emptySeries,
        ),
      },
    );
    test('True Range Result should have correct length', () async {
      final res = TA.tr(quotes);
      final _ = await quotes.close();
      final result = await res.toList();
      expect(result.length, 502);
    });
    test('Should not return any nan results when handleNa = true', () async {
      final res = TA.tr(quotes);
      final _ = await quotes.close();
      final resultList = await res.toList();
      final result = resultList.where((q) => !q.value.isNaN).toList();
      expect(result.length, 502);
    });
    test('First result should be nan when handleNa set to false', () async {
      final res = TA.tr(quotes, handleNa: false);
      final _ = await quotes.close();
      final resultList = await res.toList();
      final result = resultList.where((q) => !q.value.isNaN).toList();
      expect(result.length, 501);
    });

    test('Should return the correct calculation results', () async {
      final res = TA.tr(quotes);
      final _ = await quotes.close();
      final results = await res.toList();

      expect(
        results[1].value.toPrecision(8),
        1.42,
        reason: 'should be 1.42',
      );

      expect(
        results[12].value.toPrecision(8),
        1.32,
        reason: 'should be 1.32',
      );
    });
  });
  /*
  * https://docs.google.com/spreadsheets/d/1KCe51EDHQZ_wi2Fvu2o4darQwlZnMoI1rCCdoqR-7aw/edit?usp=sharing
 * data exported from tradingview.
  */
  group('TA.tr test tradingview data', () {
    late QuoteSeries quotes2;
    setUp(
      () => {
        quotes2 = QuotesSeries.fromIterable(data2).getOrElse(
          (l) => emptySeries,
        ),
      },
    );
    test('Should return the correct true range', () async {
      final res = TA.tr(quotes2);
      final _ = await quotes2.close();
      final results = await res.toList();

      expect(
        results[1].value.toPrecision(1),
        1170.8,
        reason: 'should be 1170.8',
      );

      expect(
        results[12].value.toPrecision(1),
        2497.3,
        reason: 'should be 2497.3',
      );
      expect(
        results[145].value.toPrecision(1),
        873.3,
        reason: 'should be 873.3',
      );
      expect(
        results[402].value.toPrecision(1),
        404.9,
        reason: 'should be 404.9',
      );
    });
  });
}
