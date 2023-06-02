/*
 * Copyright (c) 2023.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

enum ErrorType { failure, unexpected, validation, conflict, notFound }

class TaError {
  final String code;
  final String description;
  final ErrorType type;
  int get numericType => type.index;

  TaError._internal(
      {required this.code, required this.description, required this.type});

  factory TaError.failure(
      {String code = "General.Failure",
      String description = "A failure has occurred."}) {
    return TaError._internal(
        code: code, description: description, type: ErrorType.failure);
  }

  factory TaError.unexpected(
      {String code = "General.Unexpected",
      String description = "An unexpected error has occurred."}) {
    return TaError._internal(
        code: code, description: description, type: ErrorType.unexpected);
  }

  factory TaError.validation(
      {String code = "General.Validation",
      String description = "A validation error has occurred."}) {
    return TaError._internal(
        code: code, description: description, type: ErrorType.validation);
  }

  factory TaError.conflict(
      {String code = "General.Conflict",
      String description = "A conflict error has occurred."}) {
    return TaError._internal(
        code: code, description: description, type: ErrorType.conflict);
  }

  factory TaError.notFound(
      {String code = "General.NotFound",
      String description = "A 'Not Found' error has occurred."}) {
    return TaError._internal(
        code: code, description: description, type: ErrorType.notFound);
  }

  factory TaError.custom(
      {required int type, required String code, required String description}) {
    return TaError._internal(
        code: code, description: description, type: ErrorType.values[type]);
  }
}
