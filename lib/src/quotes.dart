// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:fpdart/fpdart.dart';

import 'types.dart';
import 'util.dart';

Decimal _d(String s) => Decimal.parse(s);

typedef Quote = ({
  DateTime date,
  Decimal open,
  Decimal high,
  Decimal low,
  Decimal close,
  Decimal volume
});

extension Quotes on Quote {
  static Either<String, Quote> createQuote({
    required DateTime date,
    required Decimal open,
    required Decimal high,
    required Decimal low,
    required Decimal close,
    required Decimal volume,
  }) {
    final vals = [
      ("open", open),
      ("high", high),
      ("low", low),
      ("close", close),
      ("volume", volume)
    ];
    final errMsg = [
      for (final entry in vals)
        if (entry.$2.toDouble() < 0) '${entry.$1} = ${entry.$2}'
    ].join(', ');

    return switch ((errMsg, date)) {
      (final msg, _) when msg.isNotEmpty =>
        Left("Invalid Data found $errMsg OLHCV values cannot be negative"),
      (_, final dt)
          when dt.millisecondsSinceEpoch >
              DateTime.now().millisecondsSinceEpoch =>
        Left(
          'TimeStamp $dt occurs in the future and cannot be added to the series.dart',
        ),
      (_, _) => Right(
          (
            date: date,
            open: open,
            close: close,
            volume: volume,
            high: high,
            low: low
          ),
        )
    };
  }

  static Quote get empty => (
        date: Util.maxDate,
        open: Decimal.zero,
        high: Decimal.zero,
        low: Decimal.zero,
        close: Decimal.zero,
        volume: Decimal.zero
      );

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

  bool get isEmpty => date == Util.maxDate;

  static Quote fromMap(Map<String, dynamic> map) {
    return (
      date: map['date'] as DateTime,
      open: map['open'] as Decimal,
      high: map['high'] as Decimal,
      low: map['low'] as Decimal,
      close: map['close'] as Decimal,
      volume: map['volume'] as Decimal,
    );
  }

  Quote copyWith({
    DateTime? date,
    Decimal? open,
    Decimal? high,
    Decimal? low,
    Decimal? close,
    Decimal? volume,
  }) {
    return (
      date: date ?? this.date,
      open: open ?? this.open,
      high: high ?? this.high,
      low: low ?? this.low,
      close: close ?? this.close,
      volume: volume ?? this.volume,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'open': open.toDouble(),
      'high': high.toDouble(),
      'low': low.toDouble(),
      'close': close.toDouble(),
      'volume': volume.toDouble(),
    };
  }

  String toJson() => json.encode(toMap());

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
      CandlePart.hl2 => (date: date, value: hl2.toDecimal()),
      CandlePart.hlc3 => (date: date, value: hlc3.toDecimal()),
      CandlePart.oc2 => (date: date, value: oc2.toDecimal()),
      CandlePart.ohl3 => (date: date, value: ohl3.toDecimal()),
      CandlePart.ohlc4 => (date: date, value: ohl4.toDecimal()),
    };
  }
}
