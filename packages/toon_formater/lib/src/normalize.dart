import 'types.dart';

// Normalization (unknown → JsonValue)
JsonValue normalizeValue(Object? value) {
  // null
  if (value == null) {
    return null;
  }

  // Primitives
  if (value is String || value is bool) {
    return value;
  }

  // Numbers
  if (value is num) {
    if (value.isNaN || value.isInfinite) {
      return null;
    }
    // Convert to int if it's a whole number, otherwise double
    if (value is int) {
      return value;
    }
    if (value == value.truncateToDouble()) {
      return value.toInt();
    }
    return value;
  }

  // DateTime → ISO string
  if (value is DateTime) {
    return value.toIso8601String();
  }

  // List
  if (value is List) {
    return value.map((item) => normalizeValue(item)).toList();
  }

  // Set → list
  if (value is Set) {
    return value.map((item) => normalizeValue(item)).toList();
  }

  // Map → object
  if (value is Map) {
    final normalized = <String, JsonValue>{};
    for (final entry in value.entries) {
      normalized[entry.key.toString()] = normalizeValue(entry.value);
    }
    return normalized;
  }

  // Fallback: other types → null
  return null;
}

// Type guards
bool isJsonPrimitive(Object? value) {
  return value == null ||
      value is String ||
      value is num ||
      value is bool;
}

bool isJsonArray(Object? value) {
  return value is List;
}

bool isJsonObject(Object? value) {
  return value is Map<String, Object?>;
}

bool isEmptyObject(JsonObject value) {
  return value.isEmpty;
}

// Array type detection
bool isArrayOfPrimitives(JsonArray value) {
  return value.isEmpty || value.every((item) => isJsonPrimitive(item));
}

bool isArrayOfArrays(JsonArray value) {
  return value.isEmpty || value.every((item) => isJsonArray(item));
}

bool isArrayOfObjects(JsonArray value) {
  return value.isEmpty || value.every((item) => isJsonObject(item));
}

