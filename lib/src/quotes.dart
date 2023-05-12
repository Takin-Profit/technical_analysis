// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:decimal/decimal.dart';
import 'package:fpdart/fpdart.dart';

typedef Person = ({String name, int age, bool isMale, bool isFemale});

class Quote {
  final DateTime date;
  final Decimal open;
  final Decimal high;
  final Decimal low;
  final Decimal close;
  final Decimal volume;

  static Either<String, Quote> create(DateTime date, Decimal open, Decimal high,
      Decimal low, Decimal close, Decimal volume) {
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
      (var msg, _) when msg.isNotEmpty =>
        Left("Invalid Data found $errMsg OLHCV values cannot be negative"),
      (_, var dt)
          when dt.millisecondsSinceEpoch >
              DateTime.now().millisecondsSinceEpoch =>
        Left(
            'TimeStamp $dt occurs in the future and cannot be added to the series.dart'),
      (_, _) => Right(Quote._(
          date: date,
          open: open,
          close: close,
          volume: volume,
          high: high,
          low: low))
    };
  }

/* #region */
  const Quote._({
    required this.date,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Quote &&
          runtimeType == other.runtimeType &&
          date == other.date &&
          open == other.open &&
          high == other.high &&
          low == other.low &&
          close == other.close &&
          volume == other.volume);

  @override
  int get hashCode =>
      date.hashCode ^
      open.hashCode ^
      high.hashCode ^
      low.hashCode ^
      close.hashCode ^
      volume.hashCode;

  @override
  String toString() {
    return 'Quote{ date: $date, open: $open, high: $high, low: $low, close: $close, volume: $volume,}';
  }

  Quote copyWith({
    final DateTime? date,
    final Decimal? open,
    final Decimal? high,
    final Decimal? low,
    final Decimal? close,
    final Decimal? volume,
  }) {
    return Quote._(
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
      'open': open,
      'high': high,
      'low': low,
      'close': close,
      'volume': volume,
    };
  }

  factory Quote.fromMap(final Map<String, dynamic> map) {
    return Quote._(
      date: map['date'] as DateTime,
      open: map['open'] as Decimal,
      high: map['high'] as Decimal,
      low: map['low'] as Decimal,
      close: map['close'] as Decimal,
      volume: map['volume'] as Decimal,
    );
  }
}
/* #endregion */