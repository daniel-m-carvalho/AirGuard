import 'package:air_guard/domain/models/user.dart';
import 'package:air_guard/domain/enteties/user_type.dart';

/// Represents a health measure.
///
/// This class is used to represent a health measure that has been taken by a professional user.
/// It contains information about the measure's quality index, text, and the user who wrote the measure.
///
/// Properties:
/// - `id` (int): The unique identifier of the health measure.
/// - `qualityIndex` (int): The quality index of the health measure.
/// - `text` (String): The text description of the health measure.
/// - `user` (User): The user who wrote the health measure (must be a professional user).
class HealthMeasure {
  final int id;
  final int qualityIndex;
  final String text;
  final User user;

  HealthMeasure({
    required this.id,
    required this.qualityIndex,
    required this.text,
    required this.user,
  }) : assert(
            user.type == UserType.professional, 'User must be a professional');
}
