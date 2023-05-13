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
  group('TA.ema tests', () {
    test('Ema Result should have correct length', () async {
      final res = TA.ema(quotes.closePrices);
      quotes.close();
      final result = await res.toList();
      expect(result.length, 502);
    });
    test('Should return the correct number of results without nan', () async {
      final res = TA.ema(quotes.closePrices);
      quotes.close();
      final resultList = await res.toList();
      final result = resultList.where((q) => !q.value.isNaN).toList();
      expect(result.length, 483);
    });

    test('Should return the correct calculation results', () async {
      final res = TA.ema(quotes.closePrices);
      quotes.close();
      final results = await res.toList();

      final result0 = results[0];
      final result6 = results[6];
      final result29 = results[29];
      final result249 = results[249];
      final result501 = results[501];

      quotes.close();

      expect(result0.value.isNaN, true);
      expect(result6.value.isNaN, true);
      expect(result29.value.toPrecision(4), 216.6228,
          reason: 'should be 216.6228');
      expect(result249.value.toPrecision(4), 255.3873,
          reason: 'should be 255.3873');
      expect(result501.value.toPrecision(4), 249.3519,
          reason: 'should be 249.3519');
    });
  });
}