import 'package:air_guard/domain/enteties/coordinates.dart';
import 'package:air_guard/domain/models/air_quality.dart';
import 'package:air_guard/domain/models/user.dart';
import 'package:air_guard/util/either.dart';

/// Class representing an error message.
/// This class is used to encapsulate error messages for different types of errors.
///
/// Properties:
/// - `message`: A string representing the error message.
///
/// Methods:
/// - `toString()`: Returns the error message as a string.
class ErrorMessage {
  final String message;

  const ErrorMessage(this.message);

  @override
  String toString() => message;
}

/// Class representing an error in fetching air quality data.
/// This class is used to encapsulate errors that occur during the fetching of air quality data.
///
/// Properties:
/// - `message`: An instance of [ErrorMessage] containing the error message.
abstract class AirQualityError {
  const AirQualityError(ErrorMessage message);
}

/// Class representing an API error.
/// This class is used to encapsulate errors that occur during API requests.
/// It extends [AirQualityError] and provides a constant constructor for creating instances.
/// The error message for this class is a constant message indicating an unknown API error.
///
/// Properties:
/// - `message`: An instance of [ErrorMessage] containing the error message.
class ApiError extends AirQualityError {
  const ApiError()
      : super(const ErrorMessage("An unknown API error occurred."));
}

/// Class representing an invalid coordinates error.
/// This class is used to encapsulate errors that occur when invalid coordinates are provided.
/// It extends [AirQualityError] and provides a constant constructor for creating instances.
/// The error message for this class is a constant message indicating invalid coordinates.
///
/// Properties:
/// - `message`: An instance of [ErrorMessage] containing the error message.
class InvalidCoordinates extends AirQualityError {
  const InvalidCoordinates()
      : super(const ErrorMessage("Invalid coordinates."));
}

/// Class representing an invalid API key error.
/// This class is used to encapsulate errors that occur when an invalid API key is provided.
/// It extends [AirQualityError] and provides a constant constructor for creating instances.
/// The error message for this class is a constant message indicating an invalid API key.
///
/// Properties:
/// - `message`: An instance of [ErrorMessage] containing the error message.
class InvalidKey extends AirQualityError {
  const InvalidKey() : super(const ErrorMessage("Invalid API key."));
}

/// Type alias for [AirQualityResult].
typedef AirQualityResult = Either<AirQualityError, AirQuality>;

/// Class representing an error in fetching location data.
/// This class is used to encapsulate errors that occur during the fetching of location data.
///
/// Properties:
///  - `message`: An instance of [ErrorMessage] containing the error message.
abstract class LocationError {
  const LocationError(ErrorMessage message);
}

/// Class representing a location not supported error.
/// This class is used to encapsulate errors that occur when geolocation is not supported.
/// It extends [LocationError] and provides a constant constructor for creating instances.
/// The error message for this class is a constant message indicating that geolocation is not supported.
///
/// Properties:
/// - `message`: An instance of [ErrorMessage] containing the error message.
class LocationNotSupported extends LocationError {
  const LocationNotSupported()
      : super(const ErrorMessage("Geolocation is not supported."));
}

/// Class representing a location permission denied error.
/// This class is used to encapsulate errors that occur when location permission is denied.
/// It extends [LocationError] and provides a constant constructor for creating instances.
/// The error message for this class is a constant message indicating that location permission was denied by the user.
///
/// Properties:
/// - `message`: An instance of [ErrorMessage] containing the error message.
class LocationPermissionDenied extends LocationError {
  const LocationPermissionDenied()
      : super(const ErrorMessage(
            "Location permission was denied by the user. Please enable location services."));
}

/// Class representing a location service disabled error.
/// This class is used to encapsulate errors that occur when location services are disabled.
/// It extends [LocationError] and provides a constant constructor for creating instances.
/// The error message for this class is a constant message indicating that location services are disabled.
///
/// Properties:
/// - `message`: An instance of [ErrorMessage] containing the error message.
class LocationUnavailable extends LocationError {
  const LocationUnavailable()
      : super(const ErrorMessage(
            "Location information is unavailable. Please enable location services."));
}

/// Type alias for [LocationResult].
typedef LocationResult = Either<LocationError, Coordinates>;

/// Class representing an error in user authentication.
/// This class is used to encapsulate errors that occur during user authentication.
///
/// Properties:
/// - `message`: An instance of [ErrorMessage] containing the error message.
abstract class UserError {
  const UserError(ErrorMessage message);
}

/// Class representing an invalid email error.
/// This class is used to encapsulate errors that occur when an invalid email is provided.
/// It extends [UserError] and provides a constant constructor for creating instances.
/// The error message for this class is a constant message indicating an invalid email.
///
/// Properties:
/// - `message`: An instance of [ErrorMessage] containing the error message.
class InvalidEmail extends UserError {
  const InvalidEmail()
      : super(const ErrorMessage(
            "Invalid email. Please enter a valid email address (<name>@<domain>.<tld>)."));
}

/// Class representing an invalid password error.
/// This class is used to encapsulate errors that occur when an invalid password is provided.
/// It extends [UserError] and provides a constant constructor for creating instances.
/// The error message for this class is a constant message indicating an invalid password.
///
/// Properties:
/// - `message`: An instance of [ErrorMessage] containing the error message.
class InvalidPassword extends UserError {
  const InvalidPassword()
      : super(const ErrorMessage(
            "Invalid password. Password should be at least 8 characters long and"
            "contain at least one uppercase letter, one lowercase letter, one number, and one special character."));
}

/// Class representing a user not found error.
/// This class is used to encapsulate errors that occur when a user is not found.
/// It extends [UserError] and provides a constant constructor for creating instances.
/// The error message for this class is a constant message indicating that the user was not found.
///
/// Properties:
/// - `message`: An instance of [ErrorMessage] containing the error message.
class UserNotFound extends UserError {
  const UserNotFound() : super(const ErrorMessage("User not found."));
}

/// Class representing a user already exists error.
/// This class is used to encapsulate errors that occur when a user already exists.
/// It extends [UserError] and provides a constant constructor for creating instances.
/// The error message for this class is a constant message indicating that the user already exists.
///
/// Properties:
/// - `message`: An instance of [ErrorMessage] containing the error message.
class UserAlreadyExists extends UserError {
  const UserAlreadyExists()
      : super(const ErrorMessage("User already exists. Please log in."));
}

/// Type alias for [UserResult].
typedef UserResult = Either<UserError, User>;
