// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:async';

import 'package:async/async.dart';

import 'ema.dart';
import 'series.dart';
import 'types.dart';
import 'util.dart';

typedef TsiResult = ({DateTime date, double value, double? signal});

Series<TsiResult> calcTSI(
  Series<PriceDataDouble> series, {
  int lookBack = 25,
  int smoothLen = 13,
  int signalLen = 13,
}) async* {
  // correct to this point
  Stream<PriceDataDouble> doubleSmooth(
    Stream<PriceDataDouble> stream,
    int long,
    int short,
  ) {
    return calcEMA(calcEMA(stream, lookBack: long), lookBack: short);
  }

  final changeStream = Util.change(series).asBroadcastStream();

  final absChangeStream =
      changeStream.map((data) => (date: data.date, value: data.value.abs()));

  final doubleSmoothedPc = doubleSmooth(changeStream, lookBack, smoothLen);

  final doubleSmoothedAbsPc =
      doubleSmooth(absChangeStream, lookBack, smoothLen);

  final zippedStream = StreamZip([doubleSmoothedPc, doubleSmoothedAbsPc]);

  Stream<TsiResult> tsiStream() async* {
    await for (final data in zippedStream) {
      final double tsi = 100 * (data.first.value / data[1].value);
      yield (date: data.first.date, value: tsi, signal: null);
    }
  }

  final tsiWithSignalStream = tsiStream().asBroadcastStream();

  // Convert to Stream<PriceDataDouble> before calculating EMA
  final tsiPriceDataDoubleStream =
      tsiWithSignalStream.map((tsi) => (date: tsi.date, value: tsi.value));

  final signalStream = calcEMA(tsiPriceDataDoubleStream, lookBack: signalLen);

  final finalZippedStream = StreamZip([tsiWithSignalStream, signalStream]);

  await for (final data in finalZippedStream) {
    final tsiData = data.first as TsiResult;
    final signalData = data[1] as PriceDataDouble;
    yield (date: tsiData.date, value: tsiData.value, signal: signalData.value);
  }
}
