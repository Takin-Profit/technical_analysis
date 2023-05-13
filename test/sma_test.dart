// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:technical_indicators/technical_indicators.dart';
import 'package:test/test.dart';

import 'data/test_data.dart';

Future<void> main() async {
  final data = await TestData.getDefault();
  late QuoteSeries quotes;
  setUp(() => {quotes = createSeries(data)});
  group('TA tests', () {
    test('Sma Result should have correct length', () async {
      final res = TA.sma(quotes.closePrices);
      final result = await res.toList();
      quotes.close();
      expect(result.length, 502);
    });
  });
}
