/// Enum for user type
///
/// This enum represents the different types of users in the system.
/// The system supports two types of users: [citizens] and [professionals].
/// Each user type has its own set of permissions and capabilities.
library;

enum UserType {
  citizen,
  professional,
}

String userTypeToString(UserType type) {
  switch (type) {
    case UserType.citizen:
      return 'citizen';
    case UserType.professional:
      return 'professional';
    default:
      throw ArgumentError('Invalid user type: $type');
  }
}

UserType userTypeFromString(String type) {
  switch (type) {
    case 'citizen':
      return UserType.citizen;
    case 'professional':
      return UserType.professional;
    default:
      throw ArgumentError('Invalid user type: $type');
  }
}
