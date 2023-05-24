/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'circular_buffer.dart';
import 'types.dart';

Stream<PriceData> calcTCI(Stream<PriceData> series) async* {
  final buffer = CircularBuffer<PriceData>(9);
  double emaSrc = double.nan;
  double emaDiffAbs = double.nan;
  double emaTCIRaw = double.nan;
  final double multiplierSrc = 2 / (9 + 1);
  final double multiplierDiffAbs = 2 / (9 + 1);
  final double multiplierTCIRaw = 2 / (6 + 1);

  await for (final data in series) {
    buffer.add(data);

    if (buffer.isFilled) {
      if (emaSrc.isNaN) {
        emaSrc =
            buffer.map((el) => el.value).reduce((prev, next) => prev + next) /
                9;
        emaDiffAbs = buffer
                .map((el) => (el.value - emaSrc).abs())
                .reduce((prev, next) => prev + next) /
            9;
        emaTCIRaw = buffer
                .map((el) =>
                    (el.value - emaSrc) / (0.025 * (el.value - emaSrc).abs()))
                .reduce((prev, next) => prev + next) /
            6;
      } else {
        emaSrc = (data.value - emaSrc) * multiplierSrc + emaSrc;
        final diffAbs = (data.value - emaSrc).abs();
        emaDiffAbs = (diffAbs - emaDiffAbs) * multiplierDiffAbs + emaDiffAbs;
        final tciRaw = (data.value - emaSrc) / (0.025 * emaDiffAbs);
        emaTCIRaw = (tciRaw - emaTCIRaw) * multiplierTCIRaw + emaTCIRaw;
      }

      yield (date: data.date, value: emaTCIRaw + 50);
    } else {
      yield (date: data.date, value: double.nan);
    }
  }
}
