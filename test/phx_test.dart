// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

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
      expect(result.length, 686);
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
        closeTo(50.36170597, 0.001),
        reason: 'should be 50.36170597',
      );
      expect(
        result136.fast.toPrecision(8),
        43.54124617,
        reason: 'should be 43.54124617',
      );
      expect(
        result244.fast.toPrecision(8),
        66.99396323,
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
  });
}
