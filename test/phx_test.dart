// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';
import 'package:technical_analysis/src/circular_buffer.dart';
import 'package:technical_analysis/technical_analysis.dart';
import 'package:test/test.dart';

import 'data/test_data.dart';

/*
 *
 * expected results.
 * https://docs.google.com/spreadsheets/d/1Nio9ujRna5xJ3AhAHJS_BZLWp_xRGedwbxTGiuR_9dc/edit?usp=sharing
 * data exported directly from tradingview.
 */

double _linReg(List<double> data) {
  List<double> x = List.generate(
    32,
    (index) => index.toDouble(),
  );

  SimpleLinearRegression lr = SimpleLinearRegression(x, data);

  return lr.predict((data.length - 1).toDouble());
}

typedef _PhxTestResult = ({
  DateTime date,
  double fast,
  double slow,
  double lsma,
  double tci,
  double mfi,
  double willy,
  double rsi,
  double tsi,
  double csi,
});
// for testing purposes
Stream<_PhxTestResult> _calcPhxTest(QuoteSeries series) async* {
  final hlc3 = series.hlc3.asBroadcastStream();
  final tciStream = TA.tci(hlc3);
  final mfiStream = TA.mfi(series.hlc3WithVol, lookBack: 3);
  final willyStream = TA.willy(hlc3);
  final rsiStream = TA.rsi(hlc3, lookBack: 3);
  final tsiStream = TA
      .tsi(series.open, lookBack: 9, smoothLen: 6)
      .map((el) => (date: el.date, value: el.value));

  final linRegBuf = CircularBuffer<double>(32);
  final smaBuf = CircularBuffer<double>(6);

  final zipStream = ZipStream.zip5(
    tciStream,
    mfiStream,
    willyStream,
    rsiStream,
    tsiStream,
    (a, b, c, d, e) => (
      date: b.date,
      tci: a.value,
      mfi: b.value,
      willy: c.value,
      rsi: d.value,
      tsi: e.value
    ),
  );

  await for (final data in zipStream) {
    final tci = data.tci;
    final mfi = data.mfi;
    final willy = data.willy;
    final rsi = data.rsi;
    final tsi = data.tsi / 100;

    final csi = [rsi, (tsi * 50 + 50)].average;
    final phx = [tci, csi, mfi, willy].average;
    final trad = [tci, mfi, rsi].average;
    final fast = [phx, trad].average;

    smaBuf.add(fast);
    linRegBuf.add(fast);

    final linReg = linRegBuf.isFilled ? _linReg(linRegBuf) : double.nan;
    final slow = smaBuf.isFilled ? smaBuf.average : double.nan;

    yield (
      date: data.date,
      fast: fast,
      slow: slow,
      lsma: linReg,
      tsi: tsi,
      rsi: rsi,
      csi: csi,
      willy: willy,
      mfi: mfi,
      tci: tci
    );
  }
}

Future<void> main() async {
  final data = await getGoldPhx();
  late QuoteSeries quotes;
  setUp(
    () => {
      quotes = QuotesSeries.fromIterable(data).getOrElse(
        (l) => emptySeries,
      ),
    },
  );
  group('TA.phx tests', () {
    test('Phx Result should have correct length', () async {
      final res = _calcPhxTest(quotes);
      final _ = await quotes.close();
      final result = await res.toList();
      expect(result.length, 1000);
    });
    test('Should return the correct number of results without nan', () async {
      final res = TA.phx(quotes);
      final _ = await quotes.close();
      final resultList = await res.toList();
      final result = resultList.where((q) => !q.fast.isNaN).toList();
      expect(result.length, 992);
    });

    test('fast Should return the correct calculation results', () async {
      final res = _calcPhxTest(quotes);
      final _ = await quotes.close();
      final results = await res.toList();
      for (var i = 0; i < results.length; i++) {
        print('$i ${results[i]}\n');
      }
      // print(results);
      final result0 = results.first;
      final result7 = results[7];
      final result218 = results[218];
      final result223 = results[223];
      final result562 = results[562];
      final result731 = results[731];
      final result866 = results[972];

      expect(result0.fast.isNaN, true);
      expect(
        result7.fast,
        isNaN,
        reason: 'should be nan',
      );
      expect(
        result218.fast,
        80,
        reason: 'should be 80',
      );
      expect(
        result223.fast,
        20,
        reason: 'should be 20',
      );
      expect(
        result562.fast,
        64.15503,
        reason: 'should be 64.15503',
      );
      expect(
        result731.fast,
        21.756124,
        reason: 'should be 21.756124',
      );
      expect(
        result866.fast,
        69.90551288,
        reason: 'should be 69.90551288',
      );
    });

    test('slow Should return the correct calculation results', () async {
      final res = TA.phx(quotes);
      final _ = await quotes.close();
      final results = await res.toList();

      final result0 = results.first;
      final result7 = results[7];
      final result218 = results[218];
      final result223 = results[223];
      final result562 = results[562];
      final result731 = results[731];
      final result866 = results[972];

      expect(result0.fast.isNaN, true);
      expect(
        result7.slow,
        isNaN,
        reason: 'should be nan',
      );
      expect(
        result218.slow,
        80,
        reason: 'should be 80',
      );
      expect(
        result223.slow,
        20,
        reason: 'should be 20',
      );
      expect(
        result562.slow,
        64.15503,
        reason: 'should be 64.15503',
      );
      expect(
        result731.slow,
        21.756124,
        reason: 'should be 21.756124',
      );
      expect(
        result866.slow,
        69.90551288,
        reason: 'should be 69.90551288',
      );
    });

    test('lsma Should return the correct calculation results', () async {
      final res = TA.phx(quotes);
      final _ = await quotes.close();
      final results = await res.toList();

      final result0 = results.first;
      final result7 = results[7];
      final result218 = results[218];
      final result223 = results[223];
      final result562 = results[562];
      final result731 = results[731];
      final result866 = results[972];

      expect(result0.lsma.isNaN, true);
      expect(
        result7.lsma,
        isNaN,
        reason: 'should be nan',
      );
      expect(
        result218.lsma,
        80,
        reason: 'should be 80',
      );
      expect(
        result223.lsma,
        20,
        reason: 'should be 20',
      );
      expect(
        result562.lsma,
        64.15503,
        reason: 'should be 64.15503',
      );
      expect(
        result731.lsma,
        21.756124,
        reason: 'should be 21.756124',
      );
      expect(
        result866.lsma,
        69.90551288,
        reason: 'should be 69.90551288',
      );
    });
  });
}
