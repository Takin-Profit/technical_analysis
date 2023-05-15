// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:fpdart/fpdart.dart';
import 'package:technical_indicators/technical_indicators.dart';
import 'package:test/test.dart';

import 'data/test_data.dart';

Future<void> main() async {
  final data = await getDefault();
  late QuoteSeries quotes;
  setUp(() => {quotes = createSeries(data).getOrElse((l) => emptySeries)});
  group('TA.tsi tests', () {
    test('TSI Result should have correct length', () async {
      final res = TA.tsi(quotes.closePrices);
      quotes.close();
      final result = await res.toList();
      expect(result.length, 502);
    });
    test('TSI Result should have correct length', () async {
      final res = TA.tsi(quotes.closePrices);
      quotes.close();
      final result = await res.toList();
      expect(result.length, 502);
    });
    test('TSI Result should have correct length of NaN results', () async {
      final res = TA.tsi(quotes.closePrices, signalLen: 7);
      quotes.close();
      final result = await res.toList();
      final nonNaN = result.filter((x) => !x.value.isNaN);
      expect(nonNaN.length, 465, reason: 'should be 465 non NaN results');
    });
    test('TSI Signal should have correct length of NaN results', () async {
      final res = TA.tsi(quotes.closePrices, signalLen: 7);
      quotes.close();
      final result = await res.toList();
      final nonNaN = result.filter((x) => !x.signal!.isNaN);
      expect(nonNaN.length, 459,
          reason: 'should be 459 non NaN signal results');
    });
    test('TSI should return correct results', () async {
      final res = TA.tsi(quotes.closePrices, signalLen: 7);
      quotes.close();
      final result = await res.toList();

      expect(
        result[37].value.toPrecision(4),
        53.1204,
        reason: 'should be 53.1204',
      );
      expect(
        result[37].signal,
        isNaN,
        reason: 'signal should be NaN',
      );
      expect(
        result[43].value.toPrecision(4),
        46.0960,
        reason: 'should be 46.0960',
      );
      expect(
        result[43].signal?.toPrecision(4),
        51.6916,
        reason: 'signal should be 51.6916',
      );
      expect(
        result[44].value.toPrecision(4),
        42.5121,
        reason: 'should be 42.5121',
      );
      expect(
        result[44].signal?.toPrecision(4),
        49.3967,
        reason: 'signal should be 49.3967',
      );
      expect(
        result[149].value.toPrecision(4),
        29.0936,
        reason: 'should be 29.0936',
      );
      expect(
        result[149].signal?.toPrecision(4),
        28.0134,
        reason: 'signal should be 28.0134',
      );
      expect(
        result[249].value.toPrecision(4),
        41.9232,
        reason: 'should be 41.9232',
      );
      expect(
        result[249].signal?.toPrecision(4),
        42.4063,
        reason: 'signal should be 42.4063',
      );
      expect(
        result[501].value.toPrecision(4),
        -28.3513,
        reason: 'should be -28.3513',
      );
      expect(
        result[501].signal?.toPrecision(4),
        -29.3597,
        reason: 'signal should be -29.3597',
      );
    });
  });
}