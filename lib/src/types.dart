// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:convert';

typedef PriceData = ({DateTime date, double value});

extension PriceDataOps on PriceData {
  PriceData copyWith({
    DateTime? date,
    double? value,
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
      value: map['value'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  static PriceData fromJson(String source) =>
      fromMap(json.decode(source) as Map<String, dynamic>);
}
