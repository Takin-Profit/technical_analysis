// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:collection';
import 'dart:convert';

import 'package:technical_indicators/src/series.dart';

// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

typedef SmaResult = ({DateTime date, double value});

extension SmaResults on SmaResult {
  SmaResult copyWith({
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

  static SmaResult fromMap(Map<String, dynamic> map) {
    return (
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      value: map['value'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  static SmaResult fromJson(String source) =>
      fromMap(json.decode(source) as Map<String, dynamic>);
}

Series<SmaResult> calcSMA(Series<({DateTime date, double value})> series,
    {int lookBack = 20}) async* {
  final queue = Queue();
}
