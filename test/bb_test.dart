/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// ignore_for_file: prefer-correct-identifier-length

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
  });
}
