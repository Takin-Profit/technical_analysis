// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:async';

import 'ema.dart';
import 'stream_zip/stream_zip.dart';
import 'types.dart';

typedef TsiResult = ({DateTime date, double value, double? signal});

Stream<PriceDataDouble> changeWithDate(Stream<PriceDataDouble> series) async* {
  PriceDataDouble? previous;
  await for (var current in series) {
    if (previous != null) {
      yield (date: current.date, value: current.value - previous.value);
    }
    previous = current;
  }
}

Stream<TsiResult> calcTsi(Stream<PriceDataDouble> series,
    {int longLength = 25, int shortLength = 13, int signalLength = 13}) async* {
  // correct to this point
  Stream<PriceDataDouble> doubleSmooth(
      Stream<PriceDataDouble> stream, int long, int short) {
    return calcEMA(calcEMA(stream, lookBack: long), lookBack: short);
  }

  final changeStream = changeWithDate(series).asBroadcastStream();

  final absChangeStream =
      changeStream.map((data) => (date: data.date, value: data.value.abs()));

  final doubleSmoothedPc = doubleSmooth(changeStream, longLength, shortLength);

  final doubleSmoothedAbsPc =
      doubleSmooth(absChangeStream, longLength, shortLength);

  final zippedStream = StreamZip([doubleSmoothedPc, doubleSmoothedAbsPc]);

  final tsiStreamController = StreamController<TsiResult>();

  zippedStream.listen((List<PriceDataDouble> data) {
    double tsi = 100 * (data[0].value / data[1].value);
    tsiStreamController.add((date: data[0].date, value: tsi, signal: null));
  });

  final tsiStream = tsiStreamController.stream
      .map((tsiResult) => (date: tsiResult.date, value: tsiResult.value));
  final signalStream = calcEMA(tsiStream, lookBack: signalLength);

  final finalZippedStream = StreamZip([tsiStream, signalStream]);

  await for (List<PriceDataDouble> data in finalZippedStream) {
    yield (date: data[0].date, value: data[0].value, signal: data[1].value);
  }
}
