/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'package:collection/collection.dart';
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
        reason: 'should be close to 69.0622 when price = ${data[439].close}',
      );
    });
  });
}
