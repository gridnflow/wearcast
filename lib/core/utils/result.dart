import '../error/failures.dart';

/// A minimal Either-like type for passing `Failure` vs success values
/// across layer boundaries without pulling in `dartz`.
sealed class Result<T> {
  const Result();

  /// Returns the success value or null when this is a [Err].
  T? get valueOrNull => switch (this) {
        Ok<T>(value: final v) => v,
        Err<T>() => null,
      };

  /// Returns the failure or null when this is an [Ok].
  Failure? get failureOrNull => switch (this) {
        Ok<T>() => null,
        Err<T>(failure: final f) => f,
      };

  bool get isOk => this is Ok<T>;
  bool get isErr => this is Err<T>;

  R fold<R>(R Function(T value) onOk, R Function(Failure failure) onErr) {
    return switch (this) {
      Ok<T>(value: final v) => onOk(v),
      Err<T>(failure: final f) => onErr(f),
    };
  }
}

final class Ok<T> extends Result<T> {
  final T value;
  const Ok(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Ok<T> && other.value == value);

  @override
  int get hashCode => value.hashCode;
}

final class Err<T> extends Result<T> {
  final Failure failure;
  const Err(this.failure);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Err<T> && other.failure == failure);

  @override
  int get hashCode => failure.hashCode;
}
