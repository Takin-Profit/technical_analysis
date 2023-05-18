/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// ignore_for_file: prefer-correct-identifier-length,double-literal-format

import 'package:collection/collection.dart';
import 'package:technical_indicators/technical_indicators.dart';
import 'package:test/test.dart';

import 'data/test_data.dart';

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
  group('TA.bb tests', () {
    test('BB Bands Result should have correct length', () async {
      final res = TA.bb(quotes.closes);
      final _ = await quotes.close();
      final result = await res.toList();
      expect(result.length, 502);
    });
    test('Should return the correct number of results without nan', () async {
      final res = TA.bb(quotes.closes);
      final _ = await quotes.close();
      final resultList = await res.toList();
      final upper = resultList.whereNot((q) => q.upper.isNaN).toList();
      final lower = resultList.whereNot((q) => q.upper.isNaN).toList();
      final middle = resultList.whereNot((q) => q.upper.isNaN).toList();
      expect(upper.length, 483);
      expect(lower.length, 483);
      expect(middle.length, 483);
    });
    test(
      'Should return the correct values for upper band calculated',
      () async {
        final res = TA.bb(quotes.closes);
        final _ = await quotes.close();
        final results = await res.toList();
        final res249 = results[249];
        final res501 = results[501];

        expect(res249.upper.toPrecision(4), 259.5642);
        expect(res249.lower.toPrecision(4), 251.5358);
        expect(res249.middle.toPrecision(4), 255.5500);

        expect(res501.upper.toPrecision(4), 273.7004);
        expect(res501.lower.toPrecision(4), 230.0196);
        expect(res501.middle.toPrecision(4), 251.8600);
      },
    );
  });
}
