import 'left.dart';

// Abstract class representing a value of one of two possible types (a disjoint union).
abstract class Either<L, R> {
  // Constant constructor for Either.
  const Either();

  // Method to handle the Either instance.
  // It takes two functions as parameters:
  // - onLeft: Function to handle the Left case.
  // - onRight: Function to handle the Right case.
  // It returns the result of applying the appropriate function.
  T fold<T>(T Function(L failure) onLeft, T Function(R success) onRight);
}

// Function to handle an Either instance and return a new Either instance.
Either<L, T> handleEither<L, R, T>(
  // The Either instance to be processed.
  Either<L, R> either,
  // Function to handle the success case and return a new Either instance.
  Either<L, T> Function(R successValue) onSuccess,
) {
  // Use the fold method to handle the Either instance.
  // If it's a Left, return a new Left with the failure value.
  // If it's a Right, apply the onSuccess function to the success value and return the result.
  return either.fold(
    (failureValue) => Left(failureValue),
    (successValue) => onSuccess(successValue),
  );
}
