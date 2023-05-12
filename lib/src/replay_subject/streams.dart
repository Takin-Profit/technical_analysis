// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:async';

import './defer.dart';

abstract class Rx {
  /// The defer factory waits until an observer subscribes to it, and then it
  /// creates a [Stream] with the given factory function.
  ///
  /// In some circumstances, waiting until the last minute (that is, until
  /// subscription time) to generate the Stream can ensure that this
  /// Stream contains the freshest data.
  ///
  /// By default, DeferStreams are single-subscription. However, it's possible
  /// to make them reusable.
  ///
  /// ### Example
  ///
  ///     Rx.defer(() => Stream.value(1))
  ///       .listen(print); //prints 1
  static Stream<T> defer<T>(Stream<T> Function() streamFactory,
          {bool reusable = false}) =>
      DeferStream<T>(streamFactory, reusable: reusable);
}
