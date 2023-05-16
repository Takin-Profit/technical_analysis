// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
// ignore_for_file: prefer-correct-identifier-length,double-literal-format

import 'package:technical_indicators/technical_indicators.dart';
import 'package:test/test.dart';

import 'data/test_data.dart';

Future<void> main() async {
  final data = await getDefault();
  late QuoteSeries quotes;
  setUp(() => {quotes = createSeries(data).getOrElse((l) => emptySeries)});
  group('TA.change tests', () {
    test('should return correct result for 10 bars ago', () async {
      final res = TA.change(quotes.closes, length: 10);
      final _ = await quotes.close();
      final result = await res.toList();
      expect(
        result.last.value.toPrecision(5),
        -8.87000,
        reason: 'should be -8.87000',
      );
    });
    test('should return correct result for 50 bars ago', () async {
      final res = TA.change(quotes.closes, length: 50);
      final _ = await quotes.close();
      final result = await res.toList();
      expect(
        result.last.value.toPrecision(5),
        -28.36000,
        reason: 'should be -28.36000',
      );
    });
    test('should return correct result for 316 bars ago', () async {
      final res = TA.change(quotes.closes, length: 316);
      final _ = await quotes.close();
      final result = await res.toList();
      expect(
        result.last.value.toPrecision(5),
        5.68000,
        reason: 'should be 5.68000',
      );
    });
    test('should should throw exception for invalid length', () {
      expect(
        () => TA.change(quotes.closes, length: 0),
        throwsArgumentError,
        reason: 'should throw argumentError',
      );
    });
  });
}
