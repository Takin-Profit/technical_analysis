/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

import 'dart:typed_data';

typedef CircularBuf = Float64List;

extension CircularBuffer on CircularBuf {
  CircularBuf init(int size) {
    assert(size > 1, 'CircularBuffer must have a positive capacity.');

    var _ = _cap(size: size);

    return CircularBuf(size);
  }

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

  int get capacity => _cap()();

  void set _size(int value) => _size = value;

  int get _start => 0;

  void set _start(int value) => _start = value;

  void add(double value) {}
}
