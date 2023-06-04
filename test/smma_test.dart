/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

// ignore_for_file: prefer-correct-identifier-length,double-literal-format

import 'package:technical_analysis/technical_analysis.dart';
import 'package:test/test.dart';

import 'data/test_data.dart';

/*
 * expected results.
 * https://docs.google.com/spreadsheets/d/1hvrP1LDE-yjr6z5h7pvT5t4aV38nwQwDlTU2pUX_6Ss/edit?usp=sharing
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
  group('TA.smma tests', () {
    test('Smma Result should have correct length', () async {
      final res = TA.smma(quotes.closes);
      final _ = await quotes.close();
      final result = await res.toList();
      expect(result.length, 502);
    });
    test('Should return the correct number of results without nan', () async {
      final res = TA.smma(quotes.closes);
      final _ = await quotes.close();
      final resultList = await res.toList();
      final result = resultList.where((q) => !q.value.isNaN).toList();
      expect(result.length, 483);
    });

    test('Should return the correct calculation results', () async {
      final res = TA.smma(quotes.closes);
      final _ = await quotes.close();
      final results = await res.toList();

      final result18 = results[18];
      final result19 = results[19];

      expect(result18.value.isNaN, true);
      expect(result19.value.toPrecision(4), 214.5250);
      expect(results[20].value.toPrecision(4), closeTo(214.5513, 0.00012));
      expect(results[21].value.toPrecision(4), 214.5832);
      expect(results[100].value.toPrecision(4), 225.7807);
      expect(results[501].value.toPrecision(4), 255.6746);
    });
  });
}
