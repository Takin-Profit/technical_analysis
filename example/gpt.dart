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

enum MaType {
  ema,
  sma,
  smma,
  tema,
  wma,
}

class CircularBuffer<T> with ListMixin<T> {
  CircularBuffer(this.capacity)
      : assert(capacity > 1, 'CircularBuffer must have a positive capacity.'),
        _buf = [];

  CircularBuffer.of(List<T> list, [int? capacity])
      : assert(
          capacity == null || capacity >= list.length,
          'The capacity must be at least as long as the existing list',
        ),
        capacity = capacity ?? list.length,
        _buf = [...list];

  final List<T> _buf;
  final int capacity;
  int _start = 0;

  void reset() {
    _start = 0;
    _buf.clear();
  }

  @override
  void clear() => reset();

  @override
  void add(T element) {
    if (isUnfilled) {
      assert(_start == 0, 'Internal buffer grown from a bad state');
      _buf.add(element);
      return;
    }
    _buf[_start] = element;
    _start++;
    if (_start == capacity) {
      _start = 0;
    }
  }

  @override
  int get length => _buf.length;

  bool get isFilled => _buf.length == capacity;

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
