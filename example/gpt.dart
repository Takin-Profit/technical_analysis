/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

// data for gpt prompts

typedef Series<T> = Stream<T>;

class PriceData {
  final double value;
  final DateTime date;

  PriceData({required this.value, required this.date}) {}
}
