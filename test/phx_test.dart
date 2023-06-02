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
      expect(result.length, 687);
    });

    test('fast Should return the correct results', () async {
      final res = TA.phx(quotes);
      final _ = await quotes.close();
      final results = await res.toList();

      final result0 = results.first;
      final result7 = results[7];
      final result77 = results[77];
      final result136 = results[136];
      final result244 = results[244];
      final result478 = results[478];
      final result679 = results[679];

      expect(result0.fast.isNaN, true);
      expect(
        result7.fast,
        isNaN,
        reason: 'should be nan',
      );
      // still warming up data
      expect(
        result77.fast.toPrecision(8),
        closeTo(50.36170597, 0.2),
        reason: 'should be 50.36170597',
      );
      // still warming up data
      expect(
        result136.fast.toPrecision(8),
        closeTo(43.54124617, 0.05),
        reason: 'should be 43.54124617',
      );
      // still warming up data
      expect(
        result244.fast.toPrecision(8),
        closeTo(66.99396323, 0.023),
        reason: 'should be 66.99396323',
      );
      expect(
        result478.fast.toPrecision(8),
        0.95802506,
        reason: 'should be 0.95802506',
      );
      expect(
        result679.fast.toPrecision(8),
        51.81038019,
        reason: 'should be 51.81038019',
      );
    });

    test('slow Should return the correct results', () async {
      final res = TA.phx(quotes);
      final _ = await quotes.close();
      final results = await res.toList();

      final result0 = results.first;
      final result7 = results[7];
      final result77 = results[77];
      final result136 = results[136];
      final result244 = results[244];
      final result478 = results[478];
      final result679 = results[679];

      expect(result0.slow.isNaN, true);
      expect(
        result7.slow,
        isNaN,
        reason: 'should be nan',
      );
      // still warming up data
      expect(
        result77.slow.toPrecision(8),
        closeTo(79.74020294, 0.001),
        reason: 'should be 79.74020294',
      );
      expect(
        result136.slow.toPrecision(8),
        40.59035747,
        reason: 'should be 40.59035747',
      );
      expect(
        result244.slow.toPrecision(8),
        33.94287088,
        reason: 'should be 33.94287088',
      );
      expect(
        result478.slow.toPrecision(8),
        8.78840145,
        reason: 'should be 8.78840145',
      );
      expect(
        result679.slow.toPrecision(8),
        68.04603741,
        reason: 'should be 68.04603741',
      );
    });

    test('lsma Should return the correct results', () async {
      final res = TA.phx(quotes);
      final _ = await quotes.close();
      final results = await res.toList();

      final result0 = results.first;
      final result7 = results[7];
      final result77 = results[77];
      final result136 = results[136];
      final result244 = results[244];
      final result478 = results[478];
      final result679 = results[679];

      expect(result0.lsma.isNaN, true);
      expect(
        result7.lsma,
        isNaN,
        reason: 'should be nan',
      );
      // still warming up data
      expect(
        result77.lsma.toPrecision(8),
        closeTo(82.62484227, 0.001),
        reason: 'should be 82.62484227',
      );
      expect(
        result136.lsma.toPrecision(8),
        37.89349497,
        reason: 'should be 37.89349497',
      );
      expect(
        result244.lsma.toPrecision(8),
        53.06003847,
        reason: 'should be 53.06003847',
      );
      expect(
        result478.lsma.toPrecision(8),
        13.78061112,
        reason: 'should be 13.78061112',
      );
      expect(
        result679.lsma.toPrecision(8),
        72.07285066,
        reason: 'should be 72.07285066',
      );
    });
  });
}
