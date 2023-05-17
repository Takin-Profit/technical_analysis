/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

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
      quotes = QuotesSeries.fromIterable(data).getOrElse((l) => emptySeries),
    },
  );
  group('TA.mfi tests', () {
    test('MFI Result should have correct length', () async {
      final res = TA.mfi(quotes.hlc3WithVol);
      final _ = await quotes.close();
      final result = await res.toList();
      expect(result.length, 502);
    });

    test('MFI Result should have correct number of non NaN results', () async {
      final res = TA.mfi(quotes.hlc3WithVol);
      final _ = await quotes.close();
      final result = await res.toList();
      final results = result.whereNot((q) => q.value.isNaN);
      expect(results.length, 489);
    });
    test('Result dates should match', () async {
      final res = TA.mfi(quotes.hlc3WithVol);
      final _ = await quotes.close();
      final resultList = await res.toList();
      final result = resultList.toList();

      expect(
        result[439].date,
        data[439].date,
        reason: 'should have matching dates',
      );
    });

    test('Should return the correct calculation values', () async {
      final res = TA.mfi(quotes.hlc3WithVol);
      final _ = await quotes.close();
      final resultList = await res.toList();
      final result = resultList.toList();

      expect(
        result[439].value.toPrecision(4),
        69.0622,
        reason: 'should be 69.0622',
      );
      expect(
        result[501].value.toPrecision(4),
        39.9494,
        reason: 'should be 39.9494}',
      );
      expect(
        result[473].value.toPrecision(4),
        63.2747,
        reason: 'should be 63.2746',
      );
      expect(
        result[177].value.toPrecision(4),
        74.7191,
        reason: 'should be 74.7191',
      );
      expect(
        result[325].value.toPrecision(4),
        56.2805,
        reason: 'should be 56.2805',
      );
    });
  });
}
