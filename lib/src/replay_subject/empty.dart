// Copyright 2023 Takin Profit. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

class _Empty {
  const _Empty();

  @override
  String toString() => '<<EMPTY>>';
}

/// @internal
/// Sentinel object used to represent a missing value (distinct from `null`).
const Object EMPTY = _Empty(); // ignore: constant_identifier_names

/// @internal
/// Returns `null` if [o] is [EMPTY], otherwise returns itself.
T? unbox<T>(Object? o) => identical(o, EMPTY) ? null : o as T;

/// @internal
/// Returns `true` if [o] is not [EMPTY].
bool isNotEmpty(Object? o) => !identical(o, EMPTY);
