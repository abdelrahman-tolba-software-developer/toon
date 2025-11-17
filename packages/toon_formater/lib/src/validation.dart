import 'constants.dart';

/// Checks if a key can be used without quotes.
bool isValidUnquotedKey(String key) {
  return RegExp(r'^[A-Z_][\w.]*$', caseSensitive: false).hasMatch(key);
}

/// Checks if a key segment is a valid identifier for safe folding/expansion.
bool isIdentifierSegment(String key) {
  return RegExp(r'^[A-Z_]\w*$', caseSensitive: false).hasMatch(key);
}

/// Checks if a string value can be safely encoded without quotes.
bool isSafeUnquoted(String value, [String? delimiter]) {
  final delim = delimiter ?? defaultDelimiter.value;
  if (value.isEmpty) {
    return false;
  }

  if (value != value.trim()) {
    return false;
  }

  // Check if it looks like any literal value (boolean, null, or numeric)
  if (_isBooleanOrNullLiteral(value) || _isNumericLike(value)) {
    return false;
  }

  // Check for colon (always structural)
  if (value.contains(':')) {
    return false;
  }

  // Check for quotes and backslash (always need escaping)
  if (value.contains('"') || value.contains(backslash)) {
    return false;
  }

  // Check for brackets and braces (always structural)
  if (RegExp(r'[[\]{}]').hasMatch(value)) {
    return false;
  }

  // Check for control characters
  if (RegExp(r'[\n\r\t]').hasMatch(value)) {
    return false;
  }

  // Check for the active delimiter
  if (value.contains(delim)) {
    return false;
  }

  // Check for hyphen at start (list marker)
  if (value.startsWith(listItemMarker)) {
    return false;
  }

  return true;
}

bool _isBooleanOrNullLiteral(String value) {
  return value == nullLiteral || value == trueLiteral || value == falseLiteral;
}

bool _isNumericLike(String value) {
  return RegExp(r'^-?\d+(?:\.\d+)?(?:e[+-]?\d+)?$', caseSensitive: false)
          .hasMatch(value) ||
      RegExp(r'^0\d+$').hasMatch(value);
}
