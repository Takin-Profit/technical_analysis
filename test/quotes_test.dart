// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:technical_indicators/src/replay_subject/replay_subject.dart';
import 'package:technical_indicators/technical_indicators.dart';
import 'package:test/test.dart';

import 'data/test_data.dart';

final empty = ReplaySubject<Quote>();
Future<void> main() async {
  final data = await TestData.getDefault();
  late QuoteSeries quotes;
  setUp(() => {quotes = createSeries(data).getOrElse((l) => empty)});
  group('QuotesSeries tests', () {
    test('Stream should have correct length', () async {
      final res = quotes.closePrices;
      final result = await res.toList();
      quotes.close();
      expect(result.length, 502);
    });
  });
}
