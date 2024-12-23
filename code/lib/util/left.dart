import 'either.dart';

// Class representing the Left side of Either, typically used for failure.
class Left<L> extends Either<L, Never> {
  // The value of the Left instance.
  final L value;

  // Constant constructor for Left.
  const Left(this.value);

  // Override the fold method to handle the Left case.
  // It applies the onLeft function to the value.
  @override
  T fold<T>(T Function(L failure) onLeft, T Function(Never success) onRight) =>
      onLeft(value);
}

// Function to create a Left instance representing a failure.
Either<L, Never> failure<L>(L error) => Left(error);

// Type alias for Left, representing a failure.
typedef Failure<F> = Left<F>;
