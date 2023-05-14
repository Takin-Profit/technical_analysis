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
  Stream<PriceDataDouble> get closePrices =>
      stream.map((event) => event.toPriceDataDouble());

  Stream<PriceDataDouble> get openPrices => stream
      .map((event) => event.toPriceDataDouble(candlePart: CandlePart.open));

  Stream<PriceDataDouble> get volume => stream
      .map((event) => event.toPriceDataDouble(candlePart: CandlePart.volume));

  bool isValid(Quote quote) =>
      values.where((q) => q.date == quote.date).isEmpty;
}
