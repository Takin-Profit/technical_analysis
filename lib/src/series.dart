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

    final high = data.high;
    final low = data.low;
    final close = data.close;
    final open = data.open;

    return switch (candlePart) {
      CandlePart.open => (
          date: date,
          value: open,
        ),
      CandlePart.high => (
          date: date,
          value: high,
        ),
      CandlePart.low => (
          date: date,
          value: low,
        ),
      CandlePart.close => (
          date: date,
          value: close,
        ),
      CandlePart.volume => (
          date: date,
          value: data.volume,
        ),
      CandlePart.hl2 => (
          date: date,
          value: high + low / 2.0,
        ),
      CandlePart.hlc3 => (date: date, value: high + low + close / 3.0),
      CandlePart.oc2 => (date: date, value: open + close / 2.0),
      CandlePart.ohl3 => (date: date, value: open + high + low / 3.0),
      CandlePart.ohlc4 => (date: date, value: open + high + low + close / 4.0),
    };
  }

  ({DateTime date, double value, double vol}) toPriceDataDoubleWithVol({
    CandlePart candlePart = CandlePart.close,
  }) {
    final data = _toDoublePrecis();

    final high = data.high;
    final low = data.low;
    final close = data.close;
    final open = data.open;
    final volume = data.volume;

    return switch (candlePart) {
      CandlePart.open => (
          date: date,
          value: open,
          vol: volume,
        ),
      CandlePart.high => (
          date: date,
          value: high,
          vol: volume,
        ),
      CandlePart.low => (
          date: date,
          value: low,
          vol: volume,
        ),
      CandlePart.close => (
          date: date,
          value: close,
          vol: volume,
        ),
      CandlePart.volume => (
          date: date,
          value: volume,
          vol: volume,
        ),
      CandlePart.hl2 => (date: date, value: high + low / 2.0, vol: volume),
      CandlePart.hlc3 => (
          date: date,
          value: high + low + close / 3.0,
          vol: volume
        ),
      CandlePart.oc2 => (date: date, value: open + close / 2.0, vol: volume),
      CandlePart.ohl3 => (
          date: date,
          value: open + high + low / 3.0,
          vol: volume
        ),
      CandlePart.ohlc4 => (
          date: date,
          value: open + high + low + close / 4.0,
          vol: volume
        ),
    };
  }
}
