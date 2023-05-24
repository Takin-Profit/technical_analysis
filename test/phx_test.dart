// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:technical_analysis/technical_analysis.dart';
import 'package:test/test.dart';

import 'data/test_data.dart';

/*
 *
 * expected results.
 * https://docs.google.com/spreadsheets/d/1N7CzlqudWgHXad5UDaJzX93V06wZ2vdCgImugibhlQM/edit?usp=sharing
 * data exported directly from tradingview.
 */

Future<void> main() async {
  final data = await getEurUsdPhx();
  late QuoteSeries quotes;
  setUp(
    () => {
      quotes = QuotesSeries.fromIterable(data).getOrElse(
        (l) => emptySeries,
      ),
    },
  );
  group('TA.phx tests', () {
    test('Phx Result should have correct length', () async {
      final res = TA.phx(quotes);
      final _ = await quotes.close();
      final result = await res.toList();
      expect(result.length, 700);
    });
    test('Should return the correct number of results without nan', () async {
      final res = TA.phx(quotes);
      final _ = await quotes.close();
      final resultList = await res.toList();
      final result = resultList.where((q) => !q.fast.isNaN).toList();
      expect(result.length, 992);
    });

    test('fast Should return the correct calculation results', () async {
      final res = TA.phx(quotes);
      final _ = await quotes.close();
      final results = await res.toList();
      for (var i = 0; i < results.length; i++) {
        print('$i ${results[i]}\n');
      }
      // print(results);
      final result0 = results.first;
      final result7 = results[7];
      final result218 = results[218];
      final result223 = results[223];
      final result562 = results[562];
      final result731 = results[731];
      final result866 = results[972];

      expect(result0.fast.isNaN, true);
      expect(
        result7.fast,
        isNaN,
        reason: 'should be nan',
      );
      expect(
        result218.fast,
        80,
        reason: 'should be 80',
      );
      expect(
        result223.fast,
        20,
        reason: 'should be 20',
      );
      expect(
        result562.fast,
        64.15503,
        reason: 'should be 64.15503',
      );
      expect(
        result731.fast,
        21.756124,
        reason: 'should be 21.756124',
      );
      expect(
        result866.fast,
        69.90551288,
        reason: 'should be 69.90551288',
      );
    });

    test('slow Should return the correct calculation results', () async {
      final res = TA.phx(quotes);
      final _ = await quotes.close();
      final results = await res.toList();

      final result0 = results.first;
      final result7 = results[7];
      final result218 = results[218];
      final result223 = results[223];
      final result562 = results[562];
      final result731 = results[731];
      final result866 = results[972];

      expect(result0.fast.isNaN, true);
      expect(
        result7.slow,
        isNaN,
        reason: 'should be nan',
      );
      expect(
        result218.slow,
        80,
        reason: 'should be 80',
      );
      expect(
        result223.slow,
        20,
        reason: 'should be 20',
      );
      expect(
        result562.slow,
        64.15503,
        reason: 'should be 64.15503',
      );
      expect(
        result731.slow,
        21.756124,
        reason: 'should be 21.756124',
      );
      expect(
        result866.slow,
        69.90551288,
        reason: 'should be 69.90551288',
      );
    });

    test('lsma Should return the correct calculation results', () async {
      final res = TA.phx(quotes);
      final _ = await quotes.close();
      final results = await res.toList();

      final result0 = results.first;
      final result7 = results[7];
      final result218 = results[218];
      final result223 = results[223];
      final result562 = results[562];
      final result731 = results[731];
      final result866 = results[972];

      expect(result0.lsma.isNaN, true);
      expect(
        result7.lsma,
        isNaN,
        reason: 'should be nan',
      );
      expect(
        result218.lsma,
        80,
        reason: 'should be 80',
      );
      expect(
        result223.lsma,
        20,
        reason: 'should be 20',
      );
      expect(
        result562.lsma,
        64.15503,
        reason: 'should be 64.15503',
      );
      expect(
        result731.lsma,
        21.756124,
        reason: 'should be 21.756124',
      );
      expect(
        result866.lsma,
        69.90551288,
        reason: 'should be 69.90551288',
      );
    });
  });
}
