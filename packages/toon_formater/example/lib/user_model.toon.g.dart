// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// ToonGenerator
// **************************************************************************

class _UserToonGenerated {
  static String toToon(User instance) {
    final map = <String, Object?>{};
    map['name'] = instance.name;
    map['age'] = instance.age;
    map['email'] = instance.email;
    return encode(map);
  }

  static User fromToon(String toon) {
    final map = decode(toon) as Map<String, Object?>;
    return User(
        name: map['name'] as String? ?? '',
        age: (map['age'] as num?)?.toInt() ?? 0,
        email: map['email'] as String? ?? '');
  }
}
