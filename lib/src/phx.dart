/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';
import 'package:technical_analysis/src/rsi.dart';
import 'package:technical_analysis/src/tsi.dart';
import 'package:technical_analysis/src/willy.dart';

import 'circular_buffers.dart';
import 'mfi.dart';
import 'series.dart';
import 'tci.dart';
import 'util.dart';

double _linReg(List<double> data) {
  List<double> x = List.generate(
    32,
    (index) => index.toDouble(),
  );

  SimpleLinearRegression lr = SimpleLinearRegression(x, data);

  return lr.predict((data.length - 1).toDouble());
}

typedef PhxResult = ({DateTime date, double fast, double slow, double lsma});

Stream<PhxResult> calcPhx(QuoteSeries series) async* {
  final hlc3 = series.hlc3.asBroadcastStream();
  final tciStream = calcTCI(hlc3);
  final mfiStream = calcMFI(series.hlc3WithVol, lookBack: 3);
  final willyStream = calcWilly(hlc3);
  final rsiStream = calcRSI(hlc3, lookBack: 3);
  final tsiStream = calcTSI(series.open, lookBack: 9, smoothLen: 6)
      .map((el) => (date: el.date, value: el.value));

  final linRegBuf = CircularBuffer<double>(32);
  final smaBuf = CircularBuffer<double>(6);

  final zipStream = ZipStream.zip5(
    tciStream,
    mfiStream,
    willyStream,
    rsiStream,
    tsiStream,
    (a, b, c, d, e) => (
      date: b.date,
      tci: a.value,
      mfi: b.value,
      willy: c.value,
      rsi: d.value,
      tsi: e.value
    ),
  );

  await for (final data in zipStream) {
    final tci = data.tci;
    final mfi = data.mfi;
    final willy = data.willy;
    final rsi = data.rsi;
    final tsi = data.tsi / 100;

    final csi = [rsi, (tsi * 50 + 50)].average;
    final phx = [tci, csi, mfi, willy].average;
    final trad = [tci, mfi, rsi].average;
    final fast = [phx, trad].average;

    smaBuf.add(fast);
    linRegBuf.add(fast);

    final linReg = linRegBuf.isFilled ? _linReg(linRegBuf) : double.nan;
    final slow = smaBuf.isFilled ? smaBuf.average : double.nan;

    yield (date: data.date, fast: fast, slow: slow, lsma: linReg);
  }
}
