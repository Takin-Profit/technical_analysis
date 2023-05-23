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
 * https://docs.google.com/spreadsheets/d/1Nio9ujRna5xJ3AhAHJS_BZLWp_xRGedwbxTGiuR_9dc/edit?usp=sharing
 * data exported directly from tradingview.
 */

Future<void> main() async {
  final data = await getGoldWilly();
  late QuoteSeries quotes;
  setUp(
    () => {
      quotes = QuotesSeries.fromIterable(data).getOrElse(
        (l) => emptySeries,
      ),
    },
  );
  group('TA.will tests', () {
    test('Willy Result should have correct length', () async {
      final res = TA.willy(quotes.hlc3);
      final _ = await quotes.close();
      final result = await res.toList();
      expect(result.length, 1000);
    });
    test('Should return the correct number of results without nan', () async {
      final res = TA.willy(quotes.hlc3);
      final _ = await quotes.close();
      final resultList = await res.toList();
      final result = resultList.where((q) => !q.value.isNaN).toList();
      expect(result.length, 995);
    });

    test('Should return the correct calculation results', () async {
      final res = TA.willy(quotes.hlc3);
      final _ = await quotes.close();
      final results = await res.toList();

      final result0 = results.first;
      final result7 = results[7];
      final result218 = results[218];
      final result223 = results[223];
      final result562 = results[562];
      final result731 = results[731];
      final result866 = results[972];

      expect(result0.value.isNaN, true);
      expect(
        result7.value.toPrecision(6),
        64.315574,
        reason: 'should be 64.315574',
      );
      expect(
        result218.value,
        80,
        reason: 'should be 80',
      );
      expect(
        result223.value,
        20,
        reason: 'should be 20',
      );
      expect(
        result562.value.toPrecision(5),
        64.15503,
        reason: 'should be 64.15503',
      );
      expect(
        result731.value.toPrecision(6),
        21.756124,
        reason: 'should be 21.756124',
      );
      expect(
        result866.value.toPrecision(8),
        69.90551288,
        reason: 'should be 69.90551288',
      );
    });
  });
}
