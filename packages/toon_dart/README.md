# TOON Dart

Token-Oriented Object Notation (TOON) – A compact, deterministic JSON format for LLM prompts (Dart/Flutter implementation).

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  toon_formater:
    path: ../toon_formater  # or use pub.dev when published
```

## Usage

### Basic Encoding/Decoding

```dart
import 'package:toon_formater/toon_formater.dart';

void main() {
  // Encode a Dart object to TOON format
  final data = {
    'name': 'Alice',
    'age': 30,
    'tags': ['admin', 'ops', 'dev'],
  };
  
  final toon = encode(data);
  print(toon);
  // Output:
  // name: Alice
  // age: 30
  // tags[3]: admin,ops,dev
  
  // Decode TOON format back to Dart
  final decoded = decode(toon);
  print(decoded);
}
```

### With Options

```dart
import 'package:toon_formater/toon_formater.dart';

void main() {
  final data = {
    'items': [
      {'sku': 'A1', 'qty': 2, 'price': 9.99},
      {'sku': 'B2', 'qty': 1, 'price': 14.5},
    ],
  };
  
  final toon = encode(data, EncodeOptions(
    indent: 2,
    delimiter: Delimiter.comma,
    keyFolding: KeyFolding.safe,
  ));
  
  print(toon);
  // Output:
  // items[2]{sku,qty,price}:
  //   A1,2,9.99
  //   B2,1,14.5
}
```

## Flutter Model Code Generation

Use `toon_dart_generator` with `build_runner` to generate `toToon()` and `fromToon()` methods for your Flutter models.

### Setup

1. Add dependencies:

```yaml
dependencies:
  toon_formater:
    path: ../toon_formater

dev_dependencies:
  build_runner: ^2.4.0
  toon_dart_generator:
    path: ../toon_dart_generator
```

2. Annotate your model:

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

3. Run code generation:

```bash
flutter pub run build_runner build
```

4. Use generated methods:

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
  
  // Parse from TOON format
  final parsed = User.fromToon(toon);
  print(parsed.name); // Alice
}
```

### Custom Field Names

Use `@ToonField` annotation to customize serialization:

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

## Format Overview

TOON is a compact, human-readable encoding of JSON data:

- **Objects**: Key-value pairs with indentation
- **Arrays**: Inline for primitives, tabular for uniform objects
- **Primitives**: Strings, numbers, booleans, null

See the [TOON specification](https://github.com/toon-format/spec) for complete details.

## License

MIT

