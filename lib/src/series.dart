// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:fpdart/fpdart.dart';
import 'package:technical_indicators/src/types.dart';

import './replay_subject/replay_subject.dart';
import 'quotes.dart';
import 'util.dart';

typedef Series<T> = Stream<T>;

typedef QuoteSeries = ReplaySubject<Quote>;

Either<String, QuoteSeries> createSeries(Iterable<Quote> quotes) {
  final sorted = quotes.sorted((a, b) => a.date.compareTo(b.date));
  var lastDate = Util.minDate;
  final dups = sorted.where(
    (q) {
      final foundDup = lastDate == q.date;
      lastDate = q.date;
      return foundDup;
    },
  );

  if (dups.isEmpty) {
    final subj = ReplaySubject<Quote>();
    for (final q in sorted) {
      subj.add(q);
    }

    return Right(subj);
  } else {
    return Left(
      'Quotes with duplicate dates found ${dups.map((q) => q.date.toString()).join(', ')}',
    );
  }
}

extension QuoteStream on QuoteSeries {
  Series<PriceDataDouble> get closePrices => stream.map(
        (event) => event.toPriceDataDouble(),
      );

  Series<PriceDataDouble> get openPrices => stream.map(
        (event) => event.toPriceDataDouble(
          candlePart: CandlePart.open,
        ),
      );

  Series<PriceDataDouble> get volume => stream.map(
        (event) => event.toPriceDataDouble(
          candlePart: CandlePart.volume,
        ),
      );

  Series<PriceDataDouble> get hlc3 => stream.map(
        (event) => event.toPriceDataDouble(
          candlePart: CandlePart.hlc3,
        ),
      );

  Series<({DateTime date, double value, double vol})> get hlc3WithVol =>
      stream.map(
        (event) => event.toPriceDataDoubleWithVol(
          candlePart: CandlePart.hlc3,
        ),
      );

  bool isValid(Quote quote) =>
      values.where((q) => q.date == quote.date).isEmpty;
}

extension _QuoteExt on Quote {
  PriceDataDouble toPriceDataDouble({
    CandlePart candlePart = CandlePart.close,
  }) {
    final data = _toDoublePrecis();
    return switch (candlePart) {
      CandlePart.open => (
          date: date,
          value: data.open,
        ),
      CandlePart.high => (
          date: date,
          value: data.high,
        ),
      CandlePart.low => (
          date: date,
          value: data.low,
        ),
      CandlePart.close => (
          date: date,
          value: data.close,
        ),
      CandlePart.volume => (
          date: date,
          value: data.volume,
        ),
      CandlePart.hl2 => (
          date: date,
          value: data.high + data.low / 2.0,
        ),
      CandlePart.hlc3 => (
          date: date,
          value: data.high + data.low + data.close / 3.0
        ),
      CandlePart.oc2 => (date: date, value: data.open + data.close / 2.0),
      CandlePart.ohl3 => (
          date: date,
          value: data.open + data.high + data.low / 3.0
        ),
      CandlePart.ohlc4 => (
          date: date,
          value: data.open + data.high + data.low + data.close / 4.0
        ),
    };
  }

  ({DateTime date, double value, double vol}) toPriceDataDoubleWithVol({
    CandlePart candlePart = CandlePart.close,
  }) {
    final data = _toDoublePrecis();
    return switch (candlePart) {
      CandlePart.open => (
          date: date,
          value: data.open,
          vol: data.volume,
        ),
      CandlePart.high => (
          date: date,
          value: data.high,
          vol: data.volume,
        ),
      CandlePart.low => (
          date: date,
          value: data.low,
          vol: data.volume,
        ),
      CandlePart.close => (
          date: date,
          value: data.close,
          vol: data.volume,
        ),
      CandlePart.volume => (
          date: date,
          value: data.volume,
          vol: data.volume,
        ),
      CandlePart.hl2 => (
          date: date,
          value: data.high + data.low / 2.0,
          vol: data.volume
        ),
      CandlePart.hlc3 => (
          date: date,
          value: data.high + data.low + data.close / 3.0,
          vol: data.volume
        ),
      CandlePart.oc2 => (
          date: date,
          value: data.open + data.close / 2.0,
          vol: data.volume
        ),
      CandlePart.ohl3 => (
          date: date,
          value: data.open + data.high + data.low / 3.0,
          vol: data.volume
        ),
      CandlePart.ohlc4 => (
          date: date,
          value: data.open + data.high + data.low + data.close / 4.0,
          vol: data.volume
        ),
    };
  }
}
