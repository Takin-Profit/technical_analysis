/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */
import 'dart:collection';
import 'dart:math';
// ignore_for_file: prefer-correct-identifier-length
import 'dart:typed_data';

class CircularBuf {
  final Float64List _buffer;
  int _start = 0;
  int _counter = 0;

  // Provide filledSize property to return the filled size of the buffer
  int get filledSize => _counter;

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

class CircularBuffer<T> with ListMixin<T> {
  /// Creates a [CircularBuffer] with a `capacity`
  CircularBuffer(this.capacity)
      : assert(capacity > 1, 'CircularBuffer must have a positive capacity.'),
        _buf = [];

  /// Creates a [CircularBuffer] based on another `list`
  CircularBuffer.of(List<T> list, [int? capacity])
      : assert(
          capacity == null || capacity >= list.length,
          'The capacity must be at least as long as the existing list',
        ),
        capacity = capacity ?? list.length,
        _buf = [...list];

  final List<T> _buf;

  /// Maximum number of elements of [CircularBuffer]
  final int capacity;

  int _start = 0;

  /// Resets the [CircularBuffer].
  ///
  /// [capacity] is unaffected.
  void reset() {
    _start = 0;
    _buf.clear();
  }

  /// An alias to [reset].
  @override
  void clear() => reset();

  @override
  void add(T element) {
    if (isUnfilled) {
      // The internal buffer is not at its maximum size.  Grow it.
      assert(_start == 0, 'Internal buffer grown from a bad state');
      _buf.add(element);

      return;
    }

    // All space is used, so overwrite the start.
    _buf[_start] = element;
    _start++;
    if (_start == capacity) {
      _start = 0;
    }
  }

  /// Number of used elements of [CircularBuffer]
  @override
  int get length => _buf.length;

  /// The [CircularBuffer] `isFilled` if the [length]
  /// is equal to the [capacity].
  bool get isFilled => _buf.length == capacity;

  /// The [CircularBuffer] `isUnfilled` if the [length] is
  /// less than the [capacity].
  bool get isUnfilled => _buf.length < capacity;

  @override
  T operator [](int index) {
    if (index >= 0 && index < _buf.length) {
      return _buf[(_start + index) % _buf.length];
    }
    throw RangeError.index(index, this);
  }

  @override
  void operator []=(int index, T value) {
    if (index >= 0 && index < _buf.length) {
      _buf[(_start + index) % _buf.length] = value;
    } else {
      throw RangeError.index(index, this);
    }
  }

  /// The `length` mutation is forbidden
  @override
  set length(int newLength) {
    throw UnsupportedError('Cannot resize a CircularBuffer.');
  }
}
