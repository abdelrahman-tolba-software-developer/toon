import 'package:test/test.dart';
import 'package:toon_formater/src/normalize.dart';

void main() {
  group('Normalize Tests', () {
    test('normalizes null', () {
      expect(normalizeValue(null), isNull);
    });

    test('normalizes string', () {
      expect(normalizeValue('hello'), equals('hello'));
    });

    test('normalizes boolean', () {
      expect(normalizeValue(true), equals(true));
      expect(normalizeValue(false), equals(false));
    });

    test('normalizes int', () {
      expect(normalizeValue(42), equals(42));
    });

    test('normalizes double', () {
      expect(normalizeValue(3.14), equals(3.14));
    });

    test('normalizes double to int when whole number', () {
      expect(normalizeValue(42.0), equals(42));
    });

    test('normalizes NaN to null', () {
      expect(normalizeValue(double.nan), isNull);
    });

    test('normalizes infinity to null', () {
      expect(normalizeValue(double.infinity), isNull);
      expect(normalizeValue(double.negativeInfinity), isNull);
    });

    test('normalizes DateTime to ISO string', () {
      final dt = DateTime(2024, 1, 1, 12, 0, 0);
      final result = normalizeValue(dt);
      expect(result, isA<String>());
      expect(result as String, contains('2024-01-01'));
    });

    test('normalizes List', () {
      final result = normalizeValue([1, 2, 3]);
      expect(result, isA<List>());
      expect(result, equals([1, 2, 3]));
    });

    test('normalizes Set to List', () {
      final result = normalizeValue({1, 2, 3});
      expect(result, isA<List>());
      expect((result as List).length, equals(3));
    });

    test('normalizes Map', () {
      final result = normalizeValue({'key': 'value'});
      expect(result, isA<Map<String, dynamic>>());
      expect(result, equals({'key': 'value'}));
    });

    test('normalizes Map with non-string keys', () {
      final result = normalizeValue({1: 'one', 2: 'two'});
      expect(result, isA<Map<String, dynamic>>());
      expect((result as Map)['1'], equals('one'));
      expect((result as Map)['2'], equals('two'));
    });

    test('normalizes nested structures', () {
      final result = normalizeValue({
        'list': [1, 2, 3],
        'nested': {'key': 'value'}
      });
      expect(result, isA<Map>());
      final map = result as Map;
      expect(map['list'], isA<List>());
      expect(map['nested'], isA<Map>());
    });

    test('normalizes unknown type to null', () {
      expect(normalizeValue(Object()), isNull);
    });

    group('Type Guards', () {
      test('isJsonPrimitive detects primitives', () {
        expect(isJsonPrimitive(null), isTrue);
        expect(isJsonPrimitive('string'), isTrue);
        expect(isJsonPrimitive(42), isTrue);
        expect(isJsonPrimitive(3.14), isTrue);
        expect(isJsonPrimitive(true), isTrue);
        expect(isJsonPrimitive(false), isTrue);
        expect(isJsonPrimitive([]), isFalse);
        expect(isJsonPrimitive({}), isFalse);
      });

      test('isJsonArray detects arrays', () {
        expect(isJsonArray([]), isTrue);
        expect(isJsonArray([1, 2, 3]), isTrue);
        expect(isJsonArray({}), isFalse);
        expect(isJsonArray('string'), isFalse);
      });

      test('isJsonObject detects objects', () {
        expect(isJsonObject({'key': 'value'}), isTrue);
        // Empty map literal {} may not match Map<String, Object?> type exactly
        final emptyMap = <String, Object?>{};
        expect(isJsonObject(emptyMap), isTrue);
        expect(isJsonObject([]), isFalse);
        expect(isJsonObject('string'), isFalse);
        // Note: Normalized maps may have different generic types
        // so we don't test isJsonObject on normalized values
      });

      test('isEmptyObject detects empty objects', () {
        final emptyMap = <String, Object?>{};
        expect(isEmptyObject(emptyMap), isTrue);
        expect(isEmptyObject({'key': 'value'}), isFalse);
      });

      test('isArrayOfPrimitives detects primitive arrays', () {
        expect(isArrayOfPrimitives([]), isTrue);
        expect(isArrayOfPrimitives([1, 2, 3]), isTrue);
        expect(isArrayOfPrimitives(['a', 'b']), isTrue);
        expect(isArrayOfPrimitives([true, false]), isTrue);
        expect(isArrayOfPrimitives([null]), isTrue);
        expect(isArrayOfPrimitives([{}]), isFalse);
        expect(isArrayOfPrimitives([[]]), isFalse);
      });

      test('isArrayOfObjects detects object arrays', () {
        expect(isArrayOfObjects([]), isTrue);
        final emptyMap = <String, Object?>{};
        expect(isArrayOfObjects([emptyMap]), isTrue);
        expect(
            isArrayOfObjects([
              {'a': 1},
              {'b': 2}
            ]),
            isTrue);
        expect(isArrayOfObjects([1, 2, 3]), isFalse);
        expect(isArrayOfObjects(['a', 'b']), isFalse);
        // Note: Normalized arrays with maps may have different generic types
        // so we don't test isArrayOfObjects on normalized values
      });
    });
  });
}
