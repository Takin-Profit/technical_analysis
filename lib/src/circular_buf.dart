/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */
import 'dart:math';
// ignore_for_file: prefer-correct-identifier-length
import 'dart:typed_data';

class CircularBuf {
  final Float64List _buffer;
  int _start = 0;
  int _counter = 0;

  Float64List get values => isFull ? _buffer : Float64List(0);

  Iterable<double> get orderedValues sync* {
    if (isFull) {
      for (var i = 0; i < _buffer.length; i++) {
        yield _buffer[(_start + i) % _buffer.length];
      }
    }
  }

  double get first => _counter > 0 && isFull ? _buffer[_start] : double.nan;

  double get last => isFull
      ? _buffer[(_start - 1 + _buffer.length) % _buffer.length]
      : double.nan;

  int get length => _buffer.length;

  bool get isFull => _counter >= _buffer.length;

  CircularBuf({required int size}) : _buffer = Float64List(size);

  void put(double value) {
    _buffer[_start] = value;
    _start = (_start + 1) % _buffer.length;
    _counter = min(_counter + 1, _buffer.length);
  }
}
