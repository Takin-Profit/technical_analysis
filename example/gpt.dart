/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

// data for gpt prompts

typedef Series<T> = Stream<T>;

class PriceData {
  final double value;
  final DateTime date;

  PriceData({required this.value, required this.date}) {}
}

enum MaType {
  ema,
  sma,
  smma,
  tema,
  wma,
}

class Quote {
  final DateTime date;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;

  Quote(
      {required this.date,
      required this.open,
      required this.high,
      required this.low,
      required this.close,
      required this.volume});
}
