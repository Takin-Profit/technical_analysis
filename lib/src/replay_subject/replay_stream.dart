// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

/// An [Stream] that provides synchronous access to the emitted values
abstract class ReplayStream<T> implements Stream<T> {
  /// Synchronously get the values stored in Subject. May be empty.
  List<T> get values;

  /// Synchronously get the errors and stack traces stored in Subject. May be empty.
  List<Object> get errors;

  /// Synchronously get the stack traces of errors stored in Subject. May be empty.
  List<StackTrace?> get stackTraces;
}
