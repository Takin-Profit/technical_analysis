// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// ignore_for_file: prefer-correct-identifier-length

import 'package:technical_indicators/technical_indicators.dart';
import 'package:test/test.dart';

import 'data/test_data.dart';

Future<void> main() async {
  final data = await getDefault();
  late QuoteSeries quotes;
  setUp(() => {quotes = createSeries(data).getOrElse((l) => emptySeries)});
  group('QuotesSeries tests', () {
    test('Stream should have correct length', () async {
      final res = quotes.closePrices;
      final _ = await quotes.close();
      final result = await res.toList();
      expect(result.length, 502);
    });
  });
}
