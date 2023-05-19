// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// ignore_for_file: prefer-correct-identifier-length,double-literal-format

import 'package:technical_indicators/technical_indicators.dart';
import 'package:test/test.dart';

import 'data/test_data.dart';

/*
 * expected results.
 * https://docs.google.com/spreadsheets/d/12IZyWjG485EHuOU__1sR0c0dw2VjvI3cW_5ERvhGm_k/edit?usp=sharing
 */

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
  group('TA.sma tests', () {
    test('Sma Result should have correct length', () async {
      final res = TA.sma(quotes.closes);
      final _ = await quotes.close();
      final result = await res.toList();
      expect(result.length, 502);
    });
    test('Should return the correct number of results without nan', () async {
      final res = TA.sma(quotes.closes);
      final _ = await quotes.close();
      final resultList = await res.toList();
      final result = resultList.where((q) => !q.value.isNaN).toList();
      expect(result.length, 483);
    });

    test('Should return the correct calculation results', () async {
      final res = TA.sma(quotes.closes);
      final _ = await quotes.close();
      final results = await res.toList();

      final result18 = results[18];
      final result19 = results[19];
      final result24 = results[24];
      final result149 = results[149];
      final result249 = results[249];
      final result501 = results[501];

      expect(result18.value.isNaN, true);
      expect(result19.value.toPrecision(4), 214.5250);
      expect(result24.value.toPrecision(4), 215.0310);
      expect(result149.value.toPrecision(4), 234.9350);
      expect(result249.value.toPrecision(4), 255.5500);
      expect(result501.value.toPrecision(4), 251.8600);
    });
    test('CandlePart.open tests', () async {
      final res = TA.sma(quotes.open);
      final _ = await quotes.close();
      final results = await res.toList();

      final result18 = results[18];
      final result19 = results[19];
      final result24 = results[24];
      final result149 = results[149];
      final result249 = results[249];
      final result501 = results[501];

      expect(result18.value.isNaN, true);
      expect(result19.value.toPrecision(4), 214.3795);
      expect(result24.value.toPrecision(4), 214.9535);
      expect(result149.value.toPrecision(4), 234.8280);
      expect(result249.value.toPrecision(4), 255.6915);
      expect(result501.value.toPrecision(4), 253.1725);
    });

    test('CandlePart.volume tests', () async {
      final res = TA.sma(quotes.volume);
      final _ = await quotes.close();
      final results = await res.toList();

      expect(results.length, 502, reason: 'should be 502 total results');

      final notNaN = results.where((q) => !q.value.isNaN);

      expect(notNaN.length, 483, reason: 'should be 483 non NaN results');

      final result24 = results[24];
      final result290 = results[290];
      final result501 = results[501];

      expect(result24.value, 77293768.2, reason: 'should be 77293768.2');
      expect(result290.value, 157958070.8, reason: 'should be 157958070.8');
      expect(result501.value, 163695200, reason: 'should be 163695200');
    });
  });
}
