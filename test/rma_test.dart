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
      expect(result.length, 500);
    });
    test('quotes and results should have matching dates', () async {
      final res = TA.rma(quotes.closePrices);
      quotes.close();
      final results = await res.toList();
      expect(results[210].date, data[210].date, reason: 'Dates should match');
      expect(results[23].date, data[23].date, reason: 'Dates should match');
      expect(results[98].date, data[98].date, reason: 'Dates should match');
      expect(results[240].date, data[240].date, reason: 'Dates should match');
      expect(results[199].date, data[199].date, reason: 'Dates should match');
      expect(results[387].date, data[387].date, reason: 'Dates should match');
    });

    test('should return correct Values for eth_rma.csv', () async {
      final res = TA.rma(quotes.closePrices);
      quotes.close();
      final results = await res.toList();

      expect(results[200].value.toPrecision(4), closeTo(1297.1244, 0.01),
          reason: 'should be 1297.1244');

      expect(results[345].value.toPrecision(4), 1280.8835,
          reason: 'should be 1280.8835');
    });
  });
}
