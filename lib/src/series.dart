// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:decimal/decimal.dart';
import 'package:fpdart/fpdart.dart';
import 'package:technical_indicators/src/types.dart';

import './replay_subject/replay_subject.dart';
import 'quotes.dart';
import 'util.dart';

Decimal _d(String s) => Decimal.parse(s);

typedef Series<T> = Stream<T>;

typedef QuoteSeries = ReplaySubject<Quote>;

Either<String, QuoteSeries> _fromIterable(
  Iterable<Quote> quotes, {
  int? maxSize,
  void Function()? onListen,
  void Function()? onCancel,
  bool sync = false,
}) {
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
    final subj = ReplaySubject<Quote>(
      maxSize: maxSize,
      onListen: onListen,
      onCancel: onCancel,
      sync: sync,
    );
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

extension QuotesSeries on QuoteSeries {
  static Either<String, QuoteSeries> fromIterable(
    Iterable<Quote> quotes, {
    int? maxSize,
    void Function()? onListen,
    void Function()? onCancel,
    bool sync = false,
  }) {
    return _fromIterable(
      quotes,
      maxSize: maxSize,
      onListen: onListen,
      onCancel: onCancel,
      sync: sync,
    );
  }

  Series<PriceDataDouble> get open => stream.map(
        (event) => event.toPriceDataDouble(
          candlePart: CandlePart.open,
        ),
      );

  Series<({DateTime date, double value, double vol})> get openWithVol =>
      stream.map(
        (event) => event.toPriceDataDoubleWithVol(
          candlePart: CandlePart.open,
        ),
      );

  Series<PriceDataDouble> get high => stream.map(
        (event) => event.toPriceDataDouble(
          candlePart: CandlePart.high,
        ),
      );

  Series<({DateTime date, double value, double vol})> get highWithVol =>
      stream.map(
        (event) => event.toPriceDataDoubleWithVol(
          candlePart: CandlePart.high,
        ),
      );

  Series<PriceDataDouble> get low => stream.map(
        (event) => event.toPriceDataDouble(
          candlePart: CandlePart.low,
        ),
      );

  Series<({DateTime date, double value, double vol})> get lowWithVol =>
      stream.map(
        (event) => event.toPriceDataDoubleWithVol(
          candlePart: CandlePart.low,
        ),
      );

  /// This getter is named closes so that it does not clash with the
  /// underlying stream.close method.
  Series<PriceDataDouble> get closes => stream.map(
        (event) => event.toPriceDataDouble(),
      );

  Series<({DateTime date, double value, double vol})> get closeWithVol =>
      stream.map(
        (event) => event.toPriceDataDoubleWithVol(
          candlePart: CandlePart.close,
        ),
      );

  Series<PriceDataDouble> get volume => stream.map(
        (event) => event.toPriceDataDouble(
          candlePart: CandlePart.volume,
        ),
      );

  Series<PriceDataDouble> get hl2 => stream.map(
        (event) => event.toPriceDataDouble(
          candlePart: CandlePart.hl2,
        ),
      );

  Series<({DateTime date, double value, double vol})> get hl2WithVol =>
      stream.map(
        (event) => event.toPriceDataDoubleWithVol(
          candlePart: CandlePart.hl2,
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

  Series<PriceDataDouble> get oc2 => stream.map(
        (event) => event.toPriceDataDouble(
          candlePart: CandlePart.oc2,
        ),
      );

  Series<({DateTime date, double value, double vol})> get oc2WithVol =>
      stream.map(
        (event) => event.toPriceDataDoubleWithVol(
          candlePart: CandlePart.oc2,
        ),
      );

  Series<PriceDataDouble> get ohl3 => stream.map(
        (event) => event.toPriceDataDouble(
          candlePart: CandlePart.ohl3,
        ),
      );

  Series<({DateTime date, double value, double vol})> get ohl3WithVol =>
      stream.map(
        (event) => event.toPriceDataDoubleWithVol(
          candlePart: CandlePart.ohl3,
        ),
      );

  Series<PriceDataDouble> get ohlc4 => stream.map(
        (event) => event.toPriceDataDouble(
          candlePart: CandlePart.ohlc4,
        ),
      );

  Series<({DateTime date, double value, double vol})> get ohlc4WithVol =>
      stream.map(
        (event) => event.toPriceDataDoubleWithVol(
          candlePart: CandlePart.ohlc4,
        ),
      );

  bool isValid(Quote quote) =>
      values.where((q) => q.date == quote.date).isEmpty;
}

extension QuoteExt on Quote {
  PriceData toPriceData({CandlePart candlePart = CandlePart.close}) {
    final hl2 = (high + low) / _d('2.0');
    final hlc3 = (high + low + close) / _d('3.0');
    final oc2 = (open + close) / _d('2.0');
    final ohl3 = (open + high + low) / _d('3.0');
    final ohl4 = (open + high + low + close) / _d('4.0');

    return switch (candlePart) {
      CandlePart.open => (date: date, value: open),
      CandlePart.high => (date: date, value: high),
      CandlePart.low => (date: date, value: low),
      CandlePart.close => (date: date, value: close),
      CandlePart.volume => (date: date, value: volume),
      CandlePart.hl2 => (
          date: date,
          value: hl2.toDecimal(
            scaleOnInfinitePrecision: 19,
            toBigInt: (f) => f.toBigInt(),
          )
        ),
      CandlePart.hlc3 => (
          date: date,
          value: hlc3.toDecimal(
            scaleOnInfinitePrecision: 19,
            toBigInt: (f) => f.toBigInt(),
          )
        ),
      CandlePart.oc2 => (
          date: date,
          value: oc2.toDecimal(
            scaleOnInfinitePrecision: 19,
            toBigInt: (f) => f.toBigInt(),
          )
        ),
      CandlePart.ohl3 => (
          date: date,
          value: ohl3.toDecimal(
            scaleOnInfinitePrecision: 19,
            toBigInt: (f) => f.toBigInt(),
          )
        ),
      CandlePart.ohlc4 => (
          date: date,
          value: ohl4.toDecimal(
            scaleOnInfinitePrecision: 19,
            toBigInt: (f) => f.toBigInt(),
          )
        ),
    };
  }

  ({
    DateTime date,
    double open,
    double high,
    double low,
    double close,
    double volume
  }) _toDoublePrecis() => (
        date: date,
        open: open.toDouble(),
        close: close.toDouble(),
        high: high.toDouble(),
        low: low.toDouble(),
        volume: volume.toDouble()
      );

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
          value: toPriceData(candlePart: CandlePart.hl2).value.toDouble(),
        ),
      CandlePart.hlc3 => (
          date: date,
          value: toPriceData(candlePart: CandlePart.hlc3).value.toDouble(),
        ),
      CandlePart.oc2 => (
          date: date,
          value: toPriceData(candlePart: CandlePart.oc2).value.toDouble(),
        ),
      CandlePart.ohl3 => (
          date: date,
          value: toPriceData(candlePart: CandlePart.ohl3).value.toDouble(),
        ),
      CandlePart.ohlc4 => (
          date: date,
          value: toPriceData(candlePart: CandlePart.ohlc4).value.toDouble(),
        ),
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
      CandlePart.hl2 => (
          date: date,
          value: toPriceDataDouble(candlePart: CandlePart.hl2).value,
          vol: volume
        ),
      CandlePart.hlc3 => (
          date: date,
          value: toPriceDataDouble(candlePart: CandlePart.hlc3).value,
          vol: volume
        ),
      CandlePart.oc2 => (
          date: date,
          value: toPriceDataDouble(candlePart: CandlePart.oc2).value,
          vol: volume
        ),
      CandlePart.ohl3 => (
          date: date,
          value: toPriceDataDouble(candlePart: CandlePart.ohl3).value,
          vol: volume
        ),
      CandlePart.ohlc4 => (
          date: date,
          value: toPriceDataDouble(candlePart: CandlePart.ohlc4).value,
          vol: volume
        ),
    };
  }
}
