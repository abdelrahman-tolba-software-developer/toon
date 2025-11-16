import 'package:toon_dart_generator/toon_dart_generator.dart';
import 'package:toon_formater/toon_formater.dart';

part 'user_model.g.dart';

@ToonSerializable()
class User {
  final String name;
  final int age;
  final String email;

  User({
    required this.name,
    required this.age,
    required this.email,
  });

  // Generated methods will be in user_model.g.dart
  // String toToon();
  // static User fromToon(String toon);
}

