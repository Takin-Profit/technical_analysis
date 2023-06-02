/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'dart:convert';

import 'package:statistics/statistics.dart';

import 'ta_result.dart';
import 'util.dart';

typedef Quote = ({
  DateTime date,
  Decimal open,
  Decimal high,
  Decimal low,
  Decimal close,
  Decimal volume
});

extension Quotes on Quote {
  static TaResult<Quote> createQuote({
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
      ("volume", volume),
    ];
    final errMsg = [
      for (final entry in vals)
        if (entry.$2.toDouble() < 0) '${entry.$1} = ${entry.$2}',
    ].join(', ');

    return switch ((errMsg, date)) {
      (final msg, _) when msg.isNotEmpty =>
        TaResult.fromError(TaError.validation(
          description:
              "Invalid Data found $errMsg OLHCV values cannot be negative",
        )),
      (_, final dt)
          when dt.millisecondsSinceEpoch >
              DateTime.now().millisecondsSinceEpoch =>
        TaResult.fromError(TaError.validation(
          description:
              'TimeStamp $dt occurs in the future and cannot be added to the series.dart',
        )),
      (_, _) => TaResult.fromValue(
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

  static Quote get emptyQuote => (
        date: Util.maxDate,
        open: Decimals.nan,
        high: Decimals.nan,
        low: Decimals.nan,
        close: Decimals.nan,
        volume: Decimals.nan,
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
}
