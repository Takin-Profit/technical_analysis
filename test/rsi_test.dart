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
  group('TA.rsi tests', () {
    test('RSI Result should have correct length', () async {
      final res = TA.rsi(quotes.closePrices);
      quotes.close();
      final result = await res.toList();
      expect(result.length, 502);
    });
    test('Should return the correct number of results without nan', () async {
      final res = TA.rsi(quotes.closePrices);
      quotes.close();
      final resultList = await res.toList();
      final result = resultList.where((q) => !q.value.isNaN).toList();
      expect(result.length, 489);
    });

    test('Should return the correct calculation values', () async {
      final res = TA.rsi(quotes.closePrices);
      quotes.close();
      final resultList = await res.toList();
      final result = resultList.toList();
      expect(result[249].value.toPrecision(4), 70.9368, reason: '70.9368');
    });
  });
}
