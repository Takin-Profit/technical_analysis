/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

// ignore_for_file: prefer-correct-identifier-length

import 'package:technical_indicators/technical_indicators.dart';
import 'package:test/test.dart';

import 'data/test_data.dart';

Future<void> main() async {
  final data = await getDefault();
  late QuoteSeries quotes;
  setUp(() => {quotes = createSeries(data).getOrElse((l) => emptySeries)});
  group('TA.mfi tests', () {
    test('MFI Result should have correct length', () async {
      final res = TA.mfi(quotes.hlc3WithVol);
      final _ = await quotes.close();
      final result = await res.toList();
      expect(result.length, 502);
    });
    test('Should return the correct number of results without nan', () async {
      final res = TA.mfi(quotes.hlc3WithVol);
      final _ = await quotes.close();
      final resultList = await res.toList();
      final result = resultList.where((q) => !q.value.isNaN).toList();
      expect(result.length, 489);
    });
  });
}
