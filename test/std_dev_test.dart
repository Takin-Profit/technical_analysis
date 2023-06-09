/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

// ignore_for_file: prefer-correct-identifier-length

import 'dart:async';
import 'dart:math';

import 'package:technical_analysis/technical_analysis.dart';
import 'package:test/test.dart';

import 'data/test_data.dart';

/*
 * expected results.
 * https://docs.google.com/spreadsheets/d/1WDhEJQASNBE1FgI-TIVwqw3QK_q3wiwNv4ltFmZFv6I/edit?usp=sharing
 */

Future<void> main() async {
  late QuoteSeries quotes;
  setUp(
    () => {
      quotes = QuotesSeries.fromStream(
        getLongish(),
      ),
    },
  );
  group('stdDev of population', () {
    test(
      'Returns the correct result using population',
      () async {
        final output = TA.stdDev(
          quotes.closes,
          length: 5285,
        );

        final result = await output.elementAt(5284);

        expect(
          result.value.toPrecision(9),
          633.932098287,
          reason: 'should be 633.932098287',
        );
      },
    );
    test(
      'Returns the correct result at index using population',
      () async {
        final output = TA.stdDev(
          quotes.closes,
          length: 10,
        );

        final result = await output.elementAt(10);

        expect(
          result.value.toPrecision(2),
          13.82,
          reason: 'should be 13.82',
        );
      },
    );
    test(
      'Returns the correct result at index using population',
      () async {
        final output = TA.stdDev(
          quotes.closes,
          length: 10,
        );

        final result = await output.elementAt(133);

        expect(
          result.value.toPrecision(8),
          28.15109818,
          reason: 'should be 28.15109818',
        );
      },
    );

    test(
      'Returns the correct result at index using population',
      () async {
        final output = TA.stdDev(
          quotes.closes,
          length: 10,
        );

        final result = await output.elementAt(296);

        expect(
          result.value.toPrecision(6),
          25.679816,
          reason: 'should be 25.679816',
        );
      },
    );

    test(
      'Returns the correct result at index with length of 50',
      () async {
        final output = TA.stdDev(
          quotes.closes,
          length: 50,
        );

        final result = await output.elementAt(296);

        expect(
          result.value.toPrecision(2),
          49.87,
          reason: 'should be 49.87',
        );
      },
    );

    test(
      'Returns the correct result at index with length of 50',
      () async {
        final output = TA.stdDev(
          quotes.closes,
          length: 50,
        );

        final result = await output.elementAt(4644);

        expect(
          result.value.toPrecision(6),
          69.287489,
          reason: 'should be 69.287489',
        );
      },
    );

    test(
      'Returns the correct result at index length of 50',
      () async {
        final output = TA.stdDev(
          quotes.closes,
          length: 50,
        );

        final result = await output.elementAt(1454);

        expect(
          result.value.toPrecision(2),
          21.19,
          reason: 'should be 21.19',
        );
      },
    );

    test('Handles large amounts of data correctly', () async {
      final input = Stream.fromIterable(List<PriceData>.generate(
        10000,
        (i) => (
          date: DateTime(2022, 1, 1).add(Duration(days: i)),
          value: sin(
            i.toDouble(),
          )
        ),
      ));

      final output = await TA.stdDev(input, length: 1000).toList();

      expect(
        output.length,
        equals(10000),
      );
    });
  });

  group(
    'stdDev of sample',
    () => {
      test(
        'Returns the correct result at index length of 10',
        () async {
          final output = TA.stdDev(
            quotes.closes,
            length: 10,
            bias: StDevOf.sample,
          );

          final result = await output.elementAt(15);

          expect(
            result.value.toPrecision(2),
            22.62,
            reason: 'should be 22.62',
          );
        },
      ),
      test(
        'Returns the correct result at index length of 10',
        () async {
          final output = TA.stdDev(
            quotes.closes,
            length: 10,
            bias: StDevOf.sample,
          );

          final result = await output.elementAt(569);

          expect(
            result.value.toPrecision(4),
            13.8537,
            reason: 'should be 13.8537',
          );
        },
      ),
      test(
        'Returns the correct result at index length of 10',
        () async {
          final output = TA.stdDev(
            quotes.closes,
            length: 10,
            bias: StDevOf.sample,
          );

          final result = await output.elementAt(1441);

          expect(
            result.value.toPrecision(2),
            4.99,
            reason: 'should be 4.99',
          );
        },
      ),
      test(
        'Returns the correct result at index length of 10',
        () async {
          final output = TA.stdDev(
            quotes.closes,
            length: 10,
            bias: StDevOf.sample,
          );

          final result = await output.elementAt(2204);

          expect(
            result.value.toPrecision(6),
            23.154715,
            reason: 'should be 23.154715',
          );
        },
      ),
      test(
        'Returns the correct result at index length of 50',
        () async {
          final output = TA.stdDev(
            quotes.closes,
            length: 50,
            bias: StDevOf.sample,
          );

          final result = await output.elementAt(2204);

          expect(
            result.value.toPrecision(6),
            24.663025,
            reason: 'should be 24.663025',
          );
        },
      ),
      test(
        'Returns the correct result at index length of 50',
        () async {
          final output = TA.stdDev(
            quotes.closes,
            length: 50,
            bias: StDevOf.sample,
          );

          final result = await output.elementAt(2204);

          expect(
            result.value.toPrecision(6),
            24.663025,
            reason: 'should be 24.663025',
          );
        },
      ),
      test(
        'Returns the correct result at index length of 50',
        () async {
          final output = TA.stdDev(
            quotes.closes,
            length: 50,
            bias: StDevOf.sample,
          );

          final result = await output.elementAt(4006);

          expect(
            result.value.toPrecision(5),
            19.87444,
            reason: 'should be 19.87444',
          );
        },
      ),
    },
  );
}
