/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

// ignore_for_file: prefer-correct-identifier-length

import 'dart:async';
import 'dart:math';

import 'package:technical_indicators/technical_indicators.dart';
import 'package:test/test.dart';

import 'data/test_data.dart';

Future<void> main() async {
  late QuoteSeries quotes;
  setUp(
    () => {
      quotes = QuotesSeries.fromIterable([]).getOrElse(
        (l) => emptySeries,
      ),
    },
  );
  group('stdDev', () {
    test(
      'Calculates standard deviation correctly for a simple series',
      () async {
        final output = TA.stdDev(quotes.closes, length: 50);

        final _ = await quotes.close();
        final results = await output.toList();

        expect(results.last.value.toPrecision(9), 633.932098287);
      },
    );

    test('Handles large amounts of data correctly', () async {
      final input = Stream.fromIterable(List<PriceDataDouble>.generate(
        10000,
        (i) => (
          date: DateTime(2022, 1, 1).add(Duration(days: i)),
          value: sin(i.toDouble())
        ),
      ));

      final output = await TA.stdDev(input, length: 1000).toList();

      expect(output.length, equals(10000));
    });
  });
}
