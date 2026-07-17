/// A minimal functional Result type used by repositories so the UI can handle
/// success/failure without try/catch scattered everywhere.
sealed class Result<T> {
  const Result();

  R when<R>({
    required R Function(T data) success,
    required R Function(AppFailure failure) failure,
  }) {
    final self = this;
    return switch (self) {
      Success<T>() => success(self.data),
      Failure<T>() => failure(self.failure),
    };
  }

  bool get isSuccess => this is Success<T>;
  T? get dataOrNull => this is Success<T> ? (this as Success<T>).data : null;
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final AppFailure failure;
  const Failure(this.failure);
}

/// Human-readable failure with an optional machine code for analytics.
class AppFailure {
  final String message;
  final String? code;
  final Object? cause;

  const AppFailure(this.message, {this.code, this.cause});

  factory AppFailure.unexpected([Object? cause]) =>
      AppFailure('Something went wrong. Please try again.',
          code: 'unexpected', cause: cause);

  @override
  String toString() => 'AppFailure($code): $message';
}
