// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// ignore_for_file: avoid-top-level-members-in-tests

import 'dart:convert';
import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:path/path.dart' as p;
import 'package:rxdart/rxdart.dart';
import 'package:technical_analysis/technical_analysis.dart';

final emptySeries = ReplaySubject<Quote>();

Quote quoteFromCsv(String data, {bool useTimeStamp = false}) {
  fromTimeStamp(int timeStamp) =>
      DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);

  final row = data.split(',');
  final dt = useTimeStamp
      ? fromTimeStamp(int.parse(row.first))
      : DateTime.parse(row.first);
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

Stream<Quote> readFileStream(String fileName, {int days = 500}) =>
    File(p.absolute('test', 'data', fileName))
        .openRead()
        .transform(utf8.decoder)
        .transform(LineSplitter())
        .skip(1)
        .map(quoteFromCsv)
        .take(days);

Future<List<Quote>> _getQuotes(String fileName, int days) async {
  final file = await File(p.absolute('test', 'data', fileName)).readAsString();

  return file.split('\n').skip(1).map(quoteFromCsv).take(days).toList();
}

// DEFAULT: S&P 500 ~2 years of daily data
Future<List<Quote>> getDefault({int days = 502}) =>
    _getQuotes('default.csv', days);

// ZEROS (200)
Future<List<Quote>> getZeroes({int days = 200}) =>
    _getQuotes('zeroes.csv', days);

Future<List<Quote>> getEthRMA({int days = 500}) =>
    _getQuotes('eth_rma.csv', days);

Future<List<Quote>> getBtcMFI({int days = 820}) =>
    _getQuotes('btc_mfi.csv', days);

Stream<Quote> getLongish({int days = 5285}) =>
    readFileStream('longish.csv', days: days);
