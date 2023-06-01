/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'package:collection/collection.dart';

import 'circular_buf.dart';
import 'types.dart';

Stream<PriceData> calcTCI(
  Stream<PriceData> series, {
  int len = 9,
}) {
  final tci = getTCI(len: len);

  return series.map((data) => (date: data.date, value: tci(data.value)));
}

double Function(double) getTCI({int len = 9}) {
  double emaSrc = double.maxFinite;
  double emaDiffAbs = double.maxFinite;
  double emaTCIRaw = double.maxFinite;
  final CircularBuf dataBuffer = CircularBuf(size: len);

  return (double data) {
    dataBuffer.put(data);

    if (dataBuffer.isFull) {
      if (emaSrc == double.maxFinite) {
        // Initialize emaSrc, emaDiffAbs and emaTCIRaw using SMA
        emaSrc = dataBuffer.orderedValues.average;
        double diffSum = dataBuffer.orderedValues
            .map((val) => (val - emaSrc).abs())
            .reduce((a, b) => a + b);
        emaDiffAbs = diffSum / len;
        double tciRawSum = dataBuffer.orderedValues
            .map((val) => (val - emaSrc) / (0.025 * (val - emaSrc).abs()))
            .reduce((a, b) => a + b);
        emaTCIRaw = tciRawSum / 6;
      } else {
        // Update emaSrc, emaDiffAbs and emaTCIRaw
        emaSrc = (2 / (len + 1)) * data + (1 - 2 / (len + 1)) * emaSrc;
        double diffAbs = (data - emaSrc).abs();
        emaDiffAbs =
            (2 / (len + 1)) * diffAbs + (1 - 2 / (len + 1)) * emaDiffAbs;
        double tciRaw = (data - emaSrc) / (emaDiffAbs * 0.025);
        emaTCIRaw = (2 / (6 + 1)) * tciRaw + (1 - 2 / (6 + 1)) * emaTCIRaw;
      }

      return emaTCIRaw + 50;
    } else {
      return double.nan;
    }
  };
}
