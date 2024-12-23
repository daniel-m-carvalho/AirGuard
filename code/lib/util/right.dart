import 'either.dart';

// Class representing the Right side of Either, typically used for success.
class Right<R> extends Either<Never, R> {
  // The value of the Right instance.
  final R value;

  // Constant constructor for Right.
  const Right(this.value);

  // Override the fold method to handle the Right case.
  // It applies the onRight function to the value.
  @override
  T fold<T>(T Function(Never failure) onLeft, T Function(R success) onRight) =>
      onRight(value);
}

// Function to create a Right instance representing a success.
Either<Never, R> success<R>(R value) => Right(value);

// Type alias for Right, representing a success.
typedef Success<S> = Right<S>;
