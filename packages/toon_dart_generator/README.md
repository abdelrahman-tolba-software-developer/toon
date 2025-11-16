# TOON Dart Generator

Code generator for TOON format serialization in Flutter/Dart using `build_runner`.

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  toon_formater:
    path: ../toon_formater

dev_dependencies:
  build_runner: ^2.4.0
  toon_dart_generator:
    path: ../toon_dart_generator
```

## Usage

### 1. Annotate Your Model

```dart
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
}
```

### 2. Run Code Generation

```bash
flutter pub run build_runner build
```

Or watch for changes:

```bash
flutter pub run build_runner watch
```

### 3. Use Generated Methods

```dart
void main() {
  final user = User(
    name: 'Alice',
    age: 30,
    email: 'alice@example.com',
  );
  
  // Convert to TOON format
  final toon = user.toToon();
  print(toon);
  // Output:
  // name: Alice
  // age: 30
  // email: alice@example.com
  
  // Parse from TOON format
  final parsed = User.fromToon(toon);
  print(parsed.name); // Alice
}
```

## Annotations

### `@ToonSerializable`

Marks a class for TOON serialization code generation.

**Options:**
- `generateToToon` (default: `true`): Generate `toToon()` method
- `generateFromToon` (default: `true`): Generate `fromToon()` static method

**Example:**
```dart
@ToonSerializable(
  generateToToon: true,
  generateFromToon: true,
)
class User { ... }
```

### `@ToonField`

Customizes field serialization.

**Options:**
- `name`: Custom field name in TOON format (if different from Dart field name)
- `include` (default: `true`): Whether to include this field in serialization

**Example:**
```dart
@ToonSerializable()
class User {
  @ToonField(name: 'full_name')
  final String name;
  
  @ToonField(include: false)
  final String password; // Will not be serialized
  
  User({required this.name, required this.password});
}
```

## Generated Code

The generator creates a `.g.dart` file with:

- `String toToon()`: Instance method to convert the object to TOON format
- `static ClassName fromToon(String toon)`: Static factory method to parse TOON format

## License

MIT

