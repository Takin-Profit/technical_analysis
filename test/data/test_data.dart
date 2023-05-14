// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import "dart:io";

import "package:decimal/decimal.dart";
import 'package:path/path.dart' as p;
import "package:technical_indicators/src/replay_subject/replay_subject.dart";
import "package:technical_indicators/technical_indicators.dart";

final emptySeries = ReplaySubject<Quote>();

Quote quoteFromCsv(String data, {bool useTimeStamp = false}) {
  fromTimeStamp(int timeStamp) =>
      DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);

  final row = data.split(",");
  final dt =
      useTimeStamp ? fromTimeStamp(int.parse(row[0])) : DateTime.parse(row[0]);
  final open = Decimal.parse(double.parse(row[1]).toString());
  final high = Decimal.parse(double.parse(row[2]).toString());
  final low = Decimal.parse(double.parse(row[3]).toString());
  final close = Decimal.parse(double.parse(row[4]).toString());
  final volume = Decimal.parse(double.parse(row[5]).toString());

  return (
    date: dt,
    open: open,
    high: high,
    low: low,
    close: close,
    volume: volume
  );
}

// DEFAULT: S&P 500 ~2 years of daily data
Future<List<Quote>> getDefault({int days = 502}) async {
  final file =
      await File(p.absolute("test", "data", "default.csv")).readAsString();
  return file.split('\n').skip(1).map(quoteFromCsv).take(days).toList();
}

// ZEROS (200)
List<Quote> getZeroes({int days = 200}) {
  return File('zeroes.csv')
      .readAsStringSync()
      .split('\n')
      .skip(1)
      .map(quoteFromCsv)
      .take(days)
      .toList();
}

Future<List<Quote>> getEthRMA({int days = 500}) async {
  final file =
      await File(p.absolute("test", "data", "eth_rma.csv")).readAsString();
  return file.split('\n').skip(1).map(quoteFromCsv).take(days).toList();
}
