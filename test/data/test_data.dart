// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// ignore_for_file: avoid-top-level-members-in-tests

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:rxdart/rxdart.dart';
import 'package:statistics/statistics.dart';
import 'package:technical_analysis/technical_analysis.dart';

final emptySeries = ReplaySubject<Quote>();

Quote quoteFromCsv(String data, {bool useTimeStamp = false}) {
  fromTimeStamp(int timeStamp) =>
      DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);

  final row = data.split(',');
  final dt = useTimeStamp
      ? fromTimeStamp(int.parse(row.first))
      : DateTime.parse(row.first);
  final open = Decimal.parse(row[1]).compactedPrecision;
  final high = Decimal.parse(row[2]).compactedPrecision;
  final low = Decimal.parse(row[3]).compactedPrecision;
  final close = Decimal.parse(row[4]).compactedPrecision;
  final volume = Decimal.parse(row[5]).compactedPrecision;

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

Future<List<Quote>> _getQuotes(
  String fileName,
  int days, {
  bool useTimeStamp = false,
}) async {
  final file = await File(p.absolute('test', 'data', fileName)).readAsString();

  return file
      .split('\n')
      .skip(1)
      .map((data) => useTimeStamp
          ? quoteFromCsv(data, useTimeStamp: true)
          : quoteFromCsv(data))
      .take(days)
      .toList();
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

Future<List<Quote>> getGoldLinReg({int days = 900}) =>
    _getQuotes('gold_linreg.csv', days);

Future<List<Quote>> getGoldTci({int days = 900}) =>
    _getQuotes('gold_tci.csv', days);

Future<List<Quote>> getGoldWilly({int days = 1000}) =>
    _getQuotes('gold_willy.csv', days);

Future<List<Quote>> getEurUsdPhx({int days = 700}) =>
    _getQuotes('eurusd_phx.csv', days);

Future<List<Quote>> getCrudePercentRank({int days = 630}) =>
    _getQuotes('%_rank_crude.csv', days);

Future<List<Quote>> getEthBbw({int days = 630}) =>
    _getQuotes('eth_bbw.csv', days);

Future<List<Quote>> getSpxAlma({int days = 396}) =>
    _getQuotes('eth_bbw.csv', days);

Stream<Quote> getLongish({int days = 5285}) =>
    readFileStream('longish.csv', days: days);
