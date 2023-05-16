/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'package:technical_indicators/technical_indicators.dart';
import 'package:test/test.dart';

import 'data/test_data.dart';

Future<void> main() async {
  final data = await getDefault();
  late QuoteSeries quotes;
  setUp(() => {
        quotes = createSeries(data).getOrElse((l) => emptySeries),
      });
  group('Series tests', () {
    test('Series should have correct length', () async {
      final _ = await quotes.close();
      final result = await quotes.toList();
      expect(result.length, 502);
    });
  });
}
