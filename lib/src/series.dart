// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:technical_indicators/src/types.dart';

import './replay_subject/replay_subject.dart';
import 'quotes.dart';

typedef Series<T> = Stream<T>;

typedef QuoteSeries = ReplaySubject<Quote>;

QuoteSeries createSeries(Iterable<Quote> quotes) {
  final subj = ReplaySubject<Quote>();
  for (final q in quotes) {
    subj.add(q);
  }
  subj.close();
  return subj;
}

extension QuoteStream on QuoteSeries {
  Stream<PriceDataDouble> get closePrices =>
      stream.map((event) => event.toPriceDataDouble());

  Stream<PriceDataDouble> get openPrices => stream
      .map((event) => event.toPriceDataDouble(candlePart: CandlePart.open));
}
