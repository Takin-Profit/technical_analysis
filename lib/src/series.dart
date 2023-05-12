// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'quotes.dart';
import './replay_subject/replay_subject.dart';

typedef Series<T> = Stream<T>;

Series<Quote> createSeries(Iterable<Quote> quotes) {
  return ReplaySubject<Quote>();
}
