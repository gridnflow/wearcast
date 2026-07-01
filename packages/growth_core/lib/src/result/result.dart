import '../error/failure.dart';

/// A minimal `Either`-like type for passing [Failure] vs. success across
/// layer boundaries without pulling in `dartz`.
///
/// Extracted verbatim from wearcast's `Result`, which every other app either
/// copied or wanted. Use [Ok] / [Err] and consume with [fold].
sealed class Result<T> {
  const Result();

  /// Wraps [value] as a success.
  const factory Result.ok(T value) = Ok<T>;

  /// Wraps [failure] as an error.
  const factory Result.err(Failure failure) = Err<T>;

  /// The success value, or null when this is an [Err].
  T? get valueOrNull => switch (this) {
        Ok<T>(value: final v) => v,
        Err<T>() => null,
      };

  /// The failure, or null when this is an [Ok].
  Failure? get failureOrNull => switch (this) {
        Ok<T>() => null,
        Err<T>(failure: final f) => f,
      };

  bool get isOk => this is Ok<T>;
  bool get isErr => this is Err<T>;

  /// Collapses both branches into a single value of type [R].
  R fold<R>(R Function(T value) onOk, R Function(Failure failure) onErr) {
    return switch (this) {
      Ok<T>(value: final v) => onOk(v),
      Err<T>(failure: final f) => onErr(f),
    };
  }

  /// Maps the success value, leaving an [Err] untouched.
  Result<R> map<R>(R Function(T value) transform) {
    return switch (this) {
      Ok<T>(value: final v) => Ok<R>(transform(v)),
      Err<T>(failure: final f) => Err<R>(f),
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
      identical(this, other) || (other is Err<T> && other.failure == failure);

  @override
  int get hashCode => failure.hashCode;
}
