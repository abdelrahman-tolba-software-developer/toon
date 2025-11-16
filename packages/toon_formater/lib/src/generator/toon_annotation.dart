/// Annotation to mark a class for TOON serialization code generation.
class ToonSerializable {
  /// Whether to generate `toToon()` method
  final bool generateToToon;

  /// Whether to generate `fromToon()` method
  final bool generateFromToon;

  const ToonSerializable({
    this.generateToToon = true,
    this.generateFromToon = true,
  });
}

/// Annotation to mark a field for custom TOON serialization.
class ToonField {
  /// Custom field name in TOON format (if different from Dart field name)
  final String? name;

  /// Whether to include this field in serialization
  final bool include;

  const ToonField({
    this.name,
    this.include = true,
  });
}

