/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'circular_buf.dart';
import 'types.dart';

Stream<PriceData> calcTCI(Stream<PriceData> series) async* {
  final buffer = circularBuf(size: 9);
  double emaSrc = double.nan;
  double emaDiffAbs = double.nan;
  double emaTCIRaw = double.nan;
  final double multiplierSrc = 2 / (9 + 1);
  final double multiplierDiffAbs = 2 / (9 + 1);
  final double multiplierTCIRaw = 2 / (6 + 1);

  await for (final data in series) {
    buffer.put(data.value);

    if (buffer.isFilled) {
      if (emaSrc.isNaN) {
        emaSrc = buffer.reduce((prev, next) => prev + next) / 9;
        emaDiffAbs = buffer
                .map((el) => (el - emaSrc).abs())
                .reduce((prev, next) => prev + next) /
            9;
        emaTCIRaw = buffer
                .map((el) => (el - emaSrc) / (0.025 * (el - emaSrc).abs()))
                .reduce((prev, next) => prev + next) /
            6;
      } else {
        final val = data.value;

        emaSrc = (val - emaSrc) * multiplierSrc + emaSrc;
        final diffAbs = (data.value - emaSrc).abs();
        emaDiffAbs = (diffAbs - emaDiffAbs) * multiplierDiffAbs + emaDiffAbs;
        final tciRaw = (val - emaSrc) / (emaDiffAbs * 0.025);
        emaTCIRaw = (tciRaw - emaTCIRaw) * multiplierTCIRaw + emaTCIRaw;
      }

      yield (date: data.date, value: emaTCIRaw + 50);
    } else {
      yield (date: data.date, value: double.nan);
    }
  }
}
