/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

typedef PhxResult = ({DateTime date, double fast, double slow, double lsma});

/*
// phoenix Ascending
// Sources:
src0 = open
src1 = high
src2 = low
src3 = close
src4 = hl2
src5 = hlc3
src6 = ohlc4
src7 = ta.tr
vol = volume

// Inputs:
n1 = 9  // input(9, "Phx master")
n2 = 6  // input(6, "Phx time 1")
n3 = 3  // input(3, "Phx time 2")
//src = input(high, "VWMA Source")
offset = 0  // input(0, "VWMA Offset", minval = -500, maxval = 500)
n4 = 32  // input(32, "LSMA 1")
n5 = 0  // input(0, "LSMA 1")

// 4 principal components: tci, mf, willy, csi
tci(src) =>
    ta.ema((src - ta.ema(src, 9)) / (0.025 * ta.ema(math.abs(src - ta.ema(src, 9)), 9)), 6) + 50

mf(src) =>
    100.0 - 100.0 / (1.0 + math.sum(volume * (ta.change(src) <= 0 ? 0 : src), n3) / math.sum(volume * (ta.change(src) >= 0 ? 0 : src), n3))

willy(src) =>
    60 * (src - ta.highest(src, n2)) / (ta.highest(src, n2) - ta.lowest(src, n2)) + 80

csi(src) =>
    math.avg(ta.rsi(src, n3), ta.tsi(src0, n1, n2) * 50 + 50)

// "Phoenix Ascending" average of tci, csi, mf, willy:
phoenix(src) =>
    math.avg(tci(src), csi(src), mf(src), willy(src))

// "Tradition" average of tci, mf, rsi
tradition(src) =>
    math.avg(tci(src), mf(src), ta.rsi(src, n3))

phx1 = math.avg(phoenix(src5), tradition(src5))
phx2 = ta.sma(phx1, 6)
lsma = ta.linreg(phx1, 32, 0)
 */
