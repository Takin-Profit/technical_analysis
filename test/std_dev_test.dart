/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'dart:async';
import 'dart:math';

import 'package:technical_indicators/technical_indicators.dart';
import 'package:test/test.dart';

void main() {
  group('stdDev', () {
    test(
      'Calculates standard deviation correctly for a simple series',
      () async {
        final input = Stream.fromIterable([
          (date: DateTime(2022, 1, 1), value: 1.0),
          (date: DateTime(2022, 1, 2), value: 2.0),
          (date: DateTime(2022, 1, 3), value: 3.0),
        ]);

        final output = await TA.stdDev(input, length: 2).toList();

        final expected = [
          (date: DateTime(2022, 1, 1), value: double.nan),
          (date: DateTime(2022, 1, 2), value: 0.5),
          (date: DateTime(2022, 1, 3), value: 0.5),
        ];

        expect(output, equals(expected));
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
    test(
      'Correctly calculates standard deviation of constant series',
      () async {
        final input = Stream.fromIterable(List<PriceDataDouble>.generate(
          100000,
          (i) =>
              (date: DateTime(2022, 1, 1).add(Duration(days: i)), value: 1.0),
        ));

        final output = await TA.stdDev(input, length: 10000).toList();

        expect(output.last.value, closeTo(0, 0.001));
      },
    );
  });
}
