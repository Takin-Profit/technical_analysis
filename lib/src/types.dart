// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:decimal/decimal.dart';

typedef PriceData = ({DateTime date, Decimal value});
typedef PriceDataDouble = ({DateTime date, double value});

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
      month => Duration(days: 30),
      threeWeeks => Duration(days: 21),
      twoWeeks => Duration(days: 14),
      week => Duration(days: 7),
      thirtyDays => Duration(days: 30),
      twentyDays => Duration(days: 20),
      fifteenDays => Duration(days: 15),
      tenDays => Duration(days: 10),
      fiveDays => Duration(days: 5),
      threeDays => Duration(days: 3),
      twoDays => Duration(days: 2),
      oneDay => Duration(days: 1),
      twentyHours => Duration(hours: 20),
      eighteenHours => Duration(hours: 18),
      sixteenHours => Duration(hours: 16),
      fourteenHours => Duration(hours: 14),
      twelveHours => Duration(hours: 12),
      eightHours => Duration(hours: 8),
      tenHours => Duration(hours: 10),
      sixHours => Duration(hours: 6),
      fourHours => Duration(hours: 4),
      threeHours => Duration(hours: 3),
      twoHours => Duration(hours: 2),
      oneHour => Duration(hours: 1),
      threeHundredNinetyMin => Duration(minutes: 21),
      twoHundredSixtyMin => Duration(minutes: 21),
      oneHundredThirtyMin => Duration(minutes: 21),
      sixtyFiveMin => Duration(minutes: 21),
      fortyFiveMin => Duration(minutes: 21),
      thirtyMin => Duration(minutes: 21),
      twentyFourMin => Duration(minutes: 21),
      fifteenMin => Duration(minutes: 21),
      twelveMin => Duration(minutes: 21),
      fiveMin => Duration(minutes: 21),
      threeMin => Duration(minutes: 21),
      oneMin => Duration(minutes: 21),
    };
  }
}
