/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */
// ignore_for_file: prefer-correct-identifier-length
import 'dart:typed_data';

Float64List circularBuf({required int size}) {
  assert(size > 1, 'CircularBuffer must have a positive capacity.');

  final buffer = Float64List(0);

  var _ = buffer._cap(size: size);

  return buffer;
}

extension CircularBuf on Float64List {
  // cannot have fields on extensions, so we
  // emulate it with a closure.
  // ignore_for_file: avoid-non-null-assertion
  int Function() _cap({int? size}) {
    int? capacity;

    if (size != null) {
      capacity = size;

      return () => capacity!;
    } else {
      return () => capacity!;
    }
  }

  Float64List Function() _buffer({Float64List? buffer}) {
    Float64List? buffer_;

    if (buffer != null) {
      buffer_ = buffer;

      return () => buffer_!;
    } else {
      return () => buffer_!;
    }
  }

  int get cap => _cap()();

  void set _size(int value) => _size = value;

  int get _start => 0;

  void set _start(int value) => _start = value;

  void reset() {
    _start = 0;
    clear();
  }

  void put(double value) {
    if (isUnfilled) {
      // The internal buffer is not at its maximum size.  Grow it.
      assert(_start == 0, 'Internal buffer grown from a bad state');
      add(value);

      return;
    }

    // All space is used, so overwrite the start.
    this[_start] = value;
    _start++;
    if (_start == cap) {
      _start = 0;
    }
  }

  bool get isFilled => length == cap;

  bool get isUnfilled => length < cap;

  double operator [](int index) {
    if (index >= 0 && index < length) {
      return this[(_start + index) % length];
    }
    throw RangeError.index(index, this);
  }

  void operator []=(int index, double value) {
    if (index >= 0 && index < length) {
      this[(_start + index) % length] = value;
    } else {
      throw RangeError.index(index, this);
    }
  }

  int get length => length;

  set length(int newLength) {
    throw UnsupportedError('Cannot resize a CircularBuffer.');
  }
}
