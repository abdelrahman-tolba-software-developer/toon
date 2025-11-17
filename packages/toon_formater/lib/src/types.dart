import 'constants.dart';

// JSON types
typedef JsonPrimitive = Object?; // String, int, double, bool, null
typedef JsonObject = Map<String, JsonValue>;
typedef JsonArray = List<JsonValue>;
typedef JsonValue = Object?; // JsonPrimitive | JsonObject | JsonArray

// Encoder options
class EncodeOptions {
  final int indent;
  final Delimiter delimiter;
  final KeyFolding keyFolding;
  final int flattenDepth;

  const EncodeOptions({
    this.indent = 2,
    this.delimiter = Delimiter.comma,
    this.keyFolding = KeyFolding.off,
    this.flattenDepth = 999999999, // Large number instead of maxFinite
  });
}

enum KeyFolding {
  off,
  safe,
}

// Decoder options
class DecodeOptions {
  final int indent;
  final bool strict;
  final PathExpansion expandPaths;

  const DecodeOptions({
    this.indent = 2,
    this.strict = true,
    this.expandPaths = PathExpansion.off,
  });
}

enum PathExpansion {
  off,
  safe,
}

// Internal parsing types
class ArrayHeaderInfo {
  final String? key;
  final int length;
  final Delimiter delimiter;
  final List<String>? fields;

  ArrayHeaderInfo({
    this.key,
    required this.length,
    required this.delimiter,
    this.fields,
  });
}

class ParsedLine {
  final String raw;
  final int depth;
  final int indent;
  final String content;
  final int lineNumber;

  ParsedLine({
    required this.raw,
    required this.depth,
    required this.indent,
    required this.content,
    required this.lineNumber,
  });
}

class BlankLineInfo {
  final int lineNumber;
  final int indent;
  final int depth;

  BlankLineInfo({
    required this.lineNumber,
    required this.indent,
    required this.depth,
  });
}
