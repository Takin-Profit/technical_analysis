/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

// ignore_for_file: prefer-correct-identifier-length,double-literal-format

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
  group('TA.wpr tests', () {
    test('Williams %R Result should have correct length', () async {
      final res = TA.wpr(quotes);
      final _ = await quotes.close();
      final result = await res.toList();
      expect(result.length, 502);
    });
    test(
      'Williams %R should return the correct number of results without nan',
      () async {
        final res = TA.wpr(quotes);
        final _ = await quotes.close();
        final resultList = await res.toList();
        final result = resultList.where((q) => !q.value.isNaN).toList();
        expect(result.length, 489);
      },
    );

    test('Should return the correct calculation values', () async {
      final res = TA.wpr(quotes);
      final _ = await quotes.close();
      final q = await quotes.closes.toList();
      final resultList = await res.toList();
      final result = resultList.toList();

      expect(
        result[28].value.toPrecision(2),
        -4.40,
        reason: 'should be -4.40',
      );
      expect(
        result[343].value.toPrecision(4),
        -19.8211,
        reason: 'should be -19.8211',
      );
      expect(
        result[501].value.toPrecision(4),
        -52.0121,
        reason: 'should be -52.0121',
      );
      expect(
        result[249].value.toPrecision(4),
        -12.4561,
        reason: 'should equal -12.4561',
      );

      expect(
        result[173].value.toPrecision(2),
        -1.48,
        reason: 'should equal -1.48',
      );
    });
    test('Should throw exception with too small lookBack < 2', () async {
      final _ = await quotes.close();

      expect(
        () => TA.wpr(quotes, lookBack: 1),
        throwsArgumentError,
        reason: 'should throw',
      );
      expect(
        () => TA.wpr(quotes, lookBack: 0),
        throwsArgumentError,
        reason: 'should throw',
      );
    });
  });
}
