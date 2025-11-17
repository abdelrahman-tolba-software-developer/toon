import 'package:toon_formater/toon_formater.dart';

part 'user_model.toon.g.dart';

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

  String toToon() {
    return _UserToonGenerated.toToon(this);
  }

  static User fromToon(String toon) {
    return _UserToonGenerated.fromToon(toon);
  }

  // Generated methods will be in user_model.g.dart
  // String toToon();
  // static User fromToon(String toon);
}
