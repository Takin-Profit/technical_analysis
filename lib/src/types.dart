// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:decimal/decimal.dart';

typedef PriceData = ({DateTime date, Decimal value});
typedef PriceDataDouble = ({DateTime date, double value});

enum StDev { population, sample }

extension PriceDataOps on PriceData {
  PriceDataDouble get doublePrecis => (date: date, value: value.toDouble());

  PriceData copyWith({
    DateTime? date,
    Decimal? value,
  }) {
    return (
      date: date ?? this.date,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date.millisecondsSinceEpoch,
      'value': value,
    };
  }

  static PriceData fromMap(Map<String, dynamic> map) {
    return (
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      value: map['value'] as Decimal,
    );
  }

  String toJson() => json.encode(toMap());

  static PriceData fromJson(String source) =>
      fromMap(json.decode(source) as Map<String, dynamic>);
}

enum CandlePart {
  open,
  high,
  low,
  close,
  volume,
  hl2,
  hlc3,
  oc2,
  ohl3,
  ohlc4;

  const CandlePart();
}

enum EndType { close, highLow }

enum Match implements Comparable<Match> {
  bullConfirmed(val: 200),
  bullSignal(val: 100),
  bullBasis(val: 10),
  neutral(val: 1),
  none(val: 0),
  bearBasis(val: -10),
  bearSignal(val: -100),
  bearConfirmed(val: -200);

  const Match({required this.val});

  final int val;

  @override
  int compareTo(Match other) => val - other.val;
}

enum MaType {
  alma,
  dema,
  epma,
  ema,
  hma,
  kama,
  mama,
  sma,
  smma,
  tema,
  wma,
}

enum TimeFrame {
  month,
  threeWeeks,
  twoWeeks,
  week,
  thirtyDays,
  twentyDays,
  fifteenDays,
  tenDays,
  fiveDays,
  threeDays,
  twoDays,
  oneDay,
  twentyHours,
  eighteenHours,
  sixteenHours,
  fourteenHours,
  twelveHours,
  eightHours,
  tenHours,
  sixHours,
  fourHours,
  threeHours,
  twoHours,
  oneHour,
  threeHundredNinetyMin,
  twoHundredSixtyMin,
  oneHundredThirtyMin,
  sixtyFiveMin,
  fortyFiveMin,
  thirtyMin,
  twentyFourMin,
  fifteenMin,
  twelveMin,
  fiveMin,
  threeMin,
  oneMin;

  Duration toDuration() {
    return switch (this) {
      month => const Duration(days: 30),
      threeWeeks => const Duration(days: 21),
      twoWeeks => const Duration(days: 14),
      week => const Duration(days: 7),
      thirtyDays => const Duration(days: 30),
      twentyDays => const Duration(days: 20),
      fifteenDays => const Duration(days: 15),
      tenDays => const Duration(days: 10),
      fiveDays => const Duration(days: 5),
      threeDays => const Duration(days: 3),
      twoDays => const Duration(days: 2),
      oneDay => const Duration(days: 1),
      twentyHours => const Duration(hours: 20),
      eighteenHours => const Duration(hours: 18),
      sixteenHours => const Duration(hours: 16),
      fourteenHours => const Duration(hours: 14),
      twelveHours => const Duration(hours: 12),
      eightHours => const Duration(hours: 8),
      tenHours => const Duration(hours: 10),
      sixHours => const Duration(hours: 6),
      fourHours => const Duration(hours: 4),
      threeHours => const Duration(hours: 3),
      twoHours => const Duration(hours: 2),
      oneHour => const Duration(hours: 1),
      threeHundredNinetyMin => const Duration(minutes: 21),
      twoHundredSixtyMin => const Duration(minutes: 21),
      oneHundredThirtyMin => const Duration(minutes: 21),
      sixtyFiveMin => const Duration(minutes: 21),
      fortyFiveMin => const Duration(minutes: 21),
      thirtyMin => const Duration(minutes: 21),
      twentyFourMin => const Duration(minutes: 21),
      fifteenMin => const Duration(minutes: 21),
      twelveMin => const Duration(minutes: 21),
      fiveMin => const Duration(minutes: 21),
      threeMin => const Duration(minutes: 21),
      oneMin => const Duration(minutes: 21),
    };
  }
}
