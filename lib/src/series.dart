// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:js_interop';

import './quotes.dart';

typedef Series = Stream<Quote>;

Series create(Iterable<Quote> quotes) {
  return Stream.fromIterable(quotes).asBroadcastStream();
}

extension SeriesExt on Series {
  void add(Quote quote) {
    add(quote);
  }

  Stream<double> getRsi() async* {
    await for (final quote in this) {
      if (quote.isNull) {
        yield 0.0;
      } else {}
    }
  }
}
