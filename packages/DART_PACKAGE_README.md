# TOON Dart/Flutter Package

This directory contains the Dart/Flutter implementation of the TOON format.

## Package

### `toon_formater` - Complete TOON Package

A complete Dart/Flutter package providing TOON encoding/decoding functionality with built-in code generation.

**Location:** `packages/toon_formater/`

**Features:**
- `encode()` - Convert Dart objects to TOON format strings
- `decode()` - Parse TOON format strings to Dart objects
- Support for all TOON features: objects, arrays, primitives, tabular arrays
- Configurable options: indentation, delimiters, key folding
- **Built-in code generator** - Generate `toToon()` and `fromToon()` methods for Flutter models
- `@ToonSerializable` annotation for model classes
- `@ToonField` annotation for custom field serialization

**Basic Usage:**
```dart
import 'package:toon_formater/toon_formater.dart';

final data = {'name': 'Alice', 'age': 30};
final toon = encode(data);
final decoded = decode(toon);
```

**Flutter Model Code Generation:**
```dart
import 'package:toon_formater/toon_formater.dart';

part 'user_model.g.dart';

@ToonSerializable()
class User {
  final String name;
  final int age;
  
  User({required this.name, required this.age});
}

// After running: flutter pub run build_runner build
// Use: user.toToon() and User.fromToon(toon)
```

## Setup

### Basic Usage (Encoding/Decoding Only)

Add to `pubspec.yaml`:
```yaml
dependencies:
  toon_formater:
    path: packages/toon_formater
```

### With Code Generation for Flutter Models

Add to `pubspec.yaml`:
```yaml
dependencies:
  toon_formater:
    path: packages/toon_formater

dev_dependencies:
  build_runner: ^2.4.0
```

Run code generation:
```bash
flutter pub run build_runner build
```

## Code Generation Features

The generator is built into `toon_formater` and provides:

- **`@ToonSerializable`** - Marks a class for TOON serialization
  - `generateToToon` (default: `true`) - Generate `toToon()` method
  - `generateFromToon` (default: `true`) - Generate `fromToon()` static method

- **`@ToonField`** - Customizes field serialization
  - `name` - Custom field name in TOON format
  - `include` (default: `true`) - Whether to include this field

**Example with custom fields:**
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

## Example

See `packages/toon_formater/example/` for a complete Flutter example.

## Implementation Status

✅ Core encoding functionality (objects, arrays, primitives)
✅ Tabular array encoding
✅ **Build runner code generator (integrated)**
✅ Flutter model annotations (`@ToonSerializable`, `@ToonField`)
✅ Custom field name mapping
✅ Field inclusion/exclusion
✅ Basic decoding (simplified - full parser can be enhanced)

## Next Steps

1. Complete full decoder implementation with line-by-line parsing
2. Add comprehensive tests
3. Publish to pub.dev
4. Add more examples

## License

MIT

