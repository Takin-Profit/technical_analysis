// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
import 'package:technical_indicators/technical_indicators.dart';
import 'package:test/test.dart';

import 'data/test_data.dart';

Future<void> main() async {
  final data = await TestData.getEthRMA();
  late QuoteSeries quotes;
  setUp(() => {quotes = createSeries(data).getOrElse((l) => emptySeries)});
  group('TA.rma tests', () {
    test('Sma Result should have correct length', () async {
      final res = TA.rma(quotes.closePrices);
      quotes.close();
      final result = await res.toList();
      expect(result.length, 1000);
    });
    test('quotes and results should have matching dates', () async {
      final res = TA.rma(quotes.closePrices);
      quotes.close();
      final results = await res.toList();
      expect(results[210].date, data[210].date, reason: 'Dates should match');
      expect(results[23].date, data[23].date, reason: 'Dates should match');
      expect(results[98].date, data[98].date, reason: 'Dates should match');
      expect(results[540].date, data[540].date, reason: 'Dates should match');
      expect(results[720].date, data[720].date, reason: 'Dates should match');
      expect(results[839].date, data[839].date, reason: 'Dates should match');
    });

    test('should return correct Values for eth_rma.csv', () async {
      final res = TA.rma(quotes.closePrices);
      quotes.close();
      final results = await res.toList();
      expect(results[23].value, 833.0694, reason: 'value should be');
    });
  });
}
