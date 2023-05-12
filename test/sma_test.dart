// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:technical_indicators/technical_indicators.dart';
import 'package:test/test.dart';

import 'data/test_data.dart';

void main() {
  group('TA tests', () {
    Series<Quote> quotes = TestData.getDefault();

    test('First Test', () {
      final result = TA.sma(quotes, 'close');
      expect(awesome.isAwesome, isTrue);
    });
  });
}
