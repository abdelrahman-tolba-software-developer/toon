import 'constants.dart';
import 'string_utils.dart';
import 'types.dart';
import 'validation.dart';

/// Encodes a primitive value to a string.
String encodePrimitive(JsonPrimitive value, Delimiter delimiter) {
  if (value == null) {
    return nullLiteral;
  }

  if (value is bool) {
    return value.toString();
  }

  if (value is num) {
    return value.toString();
  }

  return encodeStringLiteral(value as String, delimiter);
}

/// Encodes a string literal, adding quotes if necessary.
String encodeStringLiteral(String value, Delimiter delimiter) {
  if (isSafeUnquoted(value, delimiter.value)) {
    return value;
  }

  return '$doubleQuote${escapeString(value)}$doubleQuote';
}

/// Encodes a key, adding quotes if necessary.
String encodeKey(String key) {
  if (isValidUnquotedKey(key)) {
    return key;
  }

  return '$doubleQuote${escapeString(key)}$doubleQuote';
}

/// Encodes and joins primitive values with a delimiter.
/// Optimized to use StringBuffer for better performance with large arrays.
String encodeAndJoinPrimitives(
  List<JsonPrimitive> values,
  Delimiter delimiter,
) {
  if (values.isEmpty) return '';
  if (values.length == 1) return encodePrimitive(values[0], delimiter);
  
  final buffer = StringBuffer();
  final delim = delimiter.value;
  buffer.write(encodePrimitive(values[0], delimiter));
  for (int i = 1; i < values.length; i++) {
    buffer.write(delim);
    buffer.write(encodePrimitive(values[i], delimiter));
  }
  return buffer.toString();
}

/// Formats an array header.
String formatHeader(
  int length, {
  String? key,
  List<String>? fields,
  Delimiter delimiter = defaultDelimiter,
}) {
  final buffer = StringBuffer();

  if (key != null) {
    buffer.write(encodeKey(key));
  }

  // Only include delimiter if it's not the default (comma)
  final delimiterStr =
      delimiter != defaultDelimiter ? delimiter.value : '';
  buffer.write('[$length$delimiterStr]');

  if (fields != null && fields.isNotEmpty) {
    buffer.write('{');
    buffer.write(encodeKey(fields[0]));
    final delim = delimiter.value;
    for (int i = 1; i < fields.length; i++) {
      buffer.write(delim);
      buffer.write(encodeKey(fields[i]));
    }
    buffer.write('}');
  }

  buffer.write(colon);

  return buffer.toString();
}

