/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */
// ignore_for_file: prefer-match-file-name

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';
import 'package:statistics/statistics.dart';
import 'package:technical_analysis/src/ta_result.dart';
import 'package:technical_analysis/technical_analysis.dart';

typedef Series<T> = Stream<T>;

typedef QuoteSeries = ReplaySubject<Quote>;

TaResult<QuoteSeries> _fromIterable(
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

    return TaResult.fromValue(subj);
  } else {
    return TaResult.fromError(
      TaError.validation(
        description:
            'Quotes with duplicate dates found ${dups.map((q) => q.date.toString()).join(', ')}',
      ),
    );
  }
}

QuoteSeries _fromStream(
  Stream<Quote> quoteStream, {
  int? maxSize,
  void Function()? onListen,
  void Function()? onCancel,
  bool sync = false,
}) {
  final subj = ReplaySubject<Quote>(
    maxSize: maxSize,
    onListen: onListen,
    onCancel: onCancel,
    sync: sync,
  );
  subj.addStream(quoteStream);

  return subj;
}

extension QuotesSeries on QuoteSeries {
  static QuoteSeries fromStream(
    Stream<Quote> quoteStream, {
    int? maxSize,
    void Function()? onListen,
    void Function()? onCancel,
    bool sync = false,
  }) =>
      _fromStream(
        quoteStream,
        maxSize: maxSize,
        onListen: onListen,
        onCancel: onCancel,
        sync: sync,
      );

  static TaResult<QuoteSeries> fromIterable(
    Iterable<Quote> quotes, {
    int? maxSize,
    void Function()? onListen,
    void Function()? onCancel,
    bool sync = false,
  }) =>
      _fromIterable(
        quotes,
        maxSize: maxSize,
        onListen: onListen,
        onCancel: onCancel,
        sync: sync,
      );

  Series<PriceData> get open => stream.map(
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

  Series<PriceData> get high => stream.map(
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

  Series<PriceData> get low => stream.map(
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
  Series<PriceData> get closes => stream.map(
        (event) => event.toPriceDataDouble(),
      );

  Series<({DateTime date, double value, double vol})> get closeWithVol =>
      stream.map(
        (event) => event.toPriceDataDoubleWithVol(
          candlePart: CandlePart.close,
        ),
      );

  Series<PriceData> get volume => stream.map(
        (event) => event.toPriceDataDouble(
          candlePart: CandlePart.volume,
        ),
      );

  Series<PriceData> get hl2 => stream.map(
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

  Series<PriceData> get hlc3 => stream.map(
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

  Series<PriceData> get oc2 => stream.map(
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

  Series<PriceData> get ohl3 => stream.map(
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

  Series<PriceData> get ohlc4 => stream.map(
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

  //  buffers the stream of quotes into lists, based on the timeframe given.
  Stream<List<Quote>> _toTimeFrame(TimeFrame timeFrame) {
    DateTime bufferStartDate = Util.minDate;

    return this.stream.bufferTest((quote) {
      if (bufferStartDate == Util.minDate) {
        bufferStartDate = quote.date;

        return false;
      } else if (quote.date.difference(bufferStartDate) >=
          timeFrame.toDuration()) {
        bufferStartDate = quote.date;

        return true;
      } else {
        return false;
      }
    });
  }

  Series<Quote> toTimeFrame(TimeFrame timeFrame) async* {
    await for (final list in _toTimeFrame(timeFrame)) {
      yield _aggregate(timeFrame.toDuration(), list);
    }
  }
}

Quote _aggregate(Duration duration, List<Quote> quotes) {
  if (quotes.isEmpty) {
    return Quotes.emptyQuote;
  }
  if (duration.isNegative || duration == Duration.zero) {
    return Quotes.emptyQuote;
  }

  return quotes
      .groupListsBy(
        (element) => element.date.roundDown(duration),
      )
      .entries
      .map(
        (element) {
          final firstQuote = element.value.first;
          final lastQuote = element.value.last;

          final high = element.value.map((q) => q.high).reduce(
                (value, element) =>
                    (value.compareTo(element) >= 0) ? value : element,
              );

          final low = element.value.map((q) => q.low).reduce(
                (value, element) =>
                    (value.compareTo(element) <= 0) ? value : element,
              );

          final volume = element.value
              .map(
                (q) => q.volume,
              )
              .reduce(
                (value, element) => value + element,
              );

          return (
            date: firstQuote.date,
            open: firstQuote.open,
            high: high,
            low: low,
            close: lastQuote.close,
            volume: volume,
          );
        },
      )
      .toList()
      .last;
}

extension QuoteExt on Quote {
  PriceDataDecimal toPriceData({CandlePart candlePart = CandlePart.close}) {
    final dc2 = 2.0.toDecimal().compactedPrecision;
    final dc3 = 3.0.toDecimal().compactedPrecision;

    return switch (candlePart) {
      CandlePart.open => (date: date, value: open),
      CandlePart.high => (date: date, value: high),
      CandlePart.low => (date: date, value: low),
      CandlePart.close => (date: date, value: close),
      CandlePart.volume => (date: date, value: volume),
      CandlePart.hl2 => (
          date: date,
          value: ((high + low) / dc2).compactedPrecision
        ),
      CandlePart.hlc3 => (
          date: date,
          value: ((high + low + close) / dc3).compactedPrecision
        ),
      CandlePart.oc2 => (
          date: date,
          value: ((open + close) / dc2).compactedPrecision
        ),
      CandlePart.ohl3 => (
          date: date,
          value: ((open + high + low) / dc3).compactedPrecision
        ),
      CandlePart.ohlc4 => (
          date: date,
          value:
              ((open + high + low + close) / 4.0.toDecimal()).compactedPrecision
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
  }) toDoublePrecis() => (
        date: date,
        open: open.toDouble(),
        close: close.toDouble(),
        high: high.toDouble(),
        low: low.toDouble(),
        volume: volume.toDouble()
      );

  PriceData toPriceDataDouble({
    CandlePart candlePart = CandlePart.close,
  }) {
    return switch (candlePart) {
      CandlePart.open => (
          date: date,
          value: open.toDouble(),
        ),
      CandlePart.high => (
          date: date,
          value: high.toDouble(),
        ),
      CandlePart.low => (
          date: date,
          value: low.toDouble(),
        ),
      CandlePart.close => (
          date: date,
          value: close.toDouble(),
        ),
      CandlePart.volume => (
          date: date,
          value: volume.toDouble(),
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
    final vol = volume.toDouble();

    return switch (candlePart) {
      CandlePart.open => (
          date: date,
          value: open.toDouble(),
          vol: vol,
        ),
      CandlePart.high => (
          date: date,
          value: high.toDouble(),
          vol: vol,
        ),
      CandlePart.low => (
          date: date,
          value: low.toDouble(),
          vol: vol,
        ),
      CandlePart.close => (
          date: date,
          value: close.toDouble(),
          vol: vol,
        ),
      CandlePart.volume => (
          date: date,
          value: vol,
          vol: vol,
        ),
      CandlePart.hl2 => (
          date: date,
          value: toPriceDataDouble(candlePart: CandlePart.hl2).value,
          vol: vol,
        ),
      CandlePart.hlc3 => (
          date: date,
          value: toPriceDataDouble(candlePart: CandlePart.hlc3).value,
          vol: vol,
        ),
      CandlePart.oc2 => (
          date: date,
          value: toPriceDataDouble(candlePart: CandlePart.oc2).value,
          vol: vol,
        ),
      CandlePart.ohl3 => (
          date: date,
          value: toPriceDataDouble(candlePart: CandlePart.ohl3).value,
          vol: vol,
        ),
      CandlePart.ohlc4 => (
          date: date,
          value: toPriceDataDouble(candlePart: CandlePart.ohlc4).value,
          vol: vol,
        ),
    };
  }
}
