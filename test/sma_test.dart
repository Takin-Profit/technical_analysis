// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
import 'package:technical_indicators/technical_indicators.dart';
import 'package:test/test.dart';

import 'data/test_data.dart';

Future<void> main() async {
  final data = await TestData.getDefault();
  late QuoteSeries quotes;
  setUp(() => {quotes = createSeries(data).getOrElse((l) => emptySeries)});
  group('TA tests', () {
    test('Sma Result should have correct length', () async {
      final res = TA.sma(quotes.closePrices);
      quotes.close();
      final result = await res.toList();
      expect(result.length, 502);
    });
    test('Should return the correct number of results without nan', () async {
      final res = TA.sma(quotes.closePrices);
      quotes.close();
      final resultList = await res.toList();
      final result = resultList.where((q) => !q.value.isNaN).toList();
      expect(result.length, 483);
    });

    test('Should return the correct calculation results', () async {
      final res = TA.sma(quotes.closePrices);
      quotes.close();
      final results = await res.toList();

      final result18 = results[18];
      final result19 = results[19];
      final result24 = results[24];
      final result149 = results[149];
      final result249 = results[249];
      final result501 = results[501];
      quotes.close();

      expect(result18.value.isNaN, true);
      expect(result19.value.toPrecision(4), 214.5250);
      expect(result24.value.toPrecision(4), 215.0310);
      expect(result149.value.toPrecision(4), 234.9350);
      expect(result249.value.toPrecision(4), 255.5500);
      expect(result501.value.toPrecision(4), 251.8600);
    });
    test('CandlePart.open tests', () async {
      final res = TA.sma(quotes.openPrices);
      quotes.close();
      final results = await res.toList();

      final result18 = results[18];
      final result19 = results[19];
      final result24 = results[24];
      final result149 = results[149];
      final result249 = results[249];
      final result501 = results[501];

      expect(result18.value.isNaN, true);
      expect(result19.value.toPrecision(4), 214.5250);
      expect(result24.value.toPrecision(4), 215.0310);
      expect(result149.value.toPrecision(4), 234.9350);
      expect(result249.value.toPrecision(4), 255.5500);
      expect(result501.value.toPrecision(4), 251.8600);
    });
  });
}
