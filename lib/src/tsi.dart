// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:async';

import 'ema.dart';
import 'stream_zip/stream_zip.dart';
import 'types.dart';
import 'util.dart';

typedef TsiResult = ({DateTime date, double value, double? signal});

Stream<TsiResult> calcTSI(Stream<PriceDataDouble> series,
    {int longLength = 25, int shortLength = 13, int signalLength = 13}) async* {
  // correct to this point
  Stream<PriceDataDouble> doubleSmooth(
      Stream<PriceDataDouble> stream, int long, int short) {
    return calcEMA(calcEMA(stream, lookBack: long), lookBack: short);
  }

  final changeStream = Util.change(series).asBroadcastStream();

  final absChangeStream =
      changeStream.map((data) => (date: data.date, value: data.value.abs()));

  final doubleSmoothedPc = doubleSmooth(changeStream, longLength, shortLength);

  final doubleSmoothedAbsPc =
      doubleSmooth(absChangeStream, longLength, shortLength);

  final zippedStream = StreamZip([doubleSmoothedPc, doubleSmoothedAbsPc]);

  Stream<TsiResult> tsiStream() async* {
    await for (List<PriceDataDouble> data in zippedStream) {
      double tsi = 100 * (data[0].value / data[1].value);
      yield (date: data[0].date, value: tsi, signal: null);
    }
  }

  final tsiWithSignalStream = tsiStream().asBroadcastStream();

  // Convert to Stream<PriceDataDouble> before calculating EMA
  final tsiPriceDataDoubleStream =
      tsiWithSignalStream.map((tsi) => (date: tsi.date, value: tsi.value));

  final signalStream =
      calcEMA(tsiPriceDataDoubleStream, lookBack: signalLength);

  final finalZippedStream = StreamZip([tsiWithSignalStream, signalStream]);

  await for (var data in finalZippedStream) {
    TsiResult tsiData = data[0] as TsiResult;
    PriceDataDouble signalData = data[1] as PriceDataDouble;
    yield (date: tsiData.date, value: tsiData.value, signal: signalData.value);
  }
}
