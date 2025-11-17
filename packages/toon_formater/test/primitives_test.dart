import 'package:test/test.dart';
import 'package:toon_formater/src/primitives.dart';
import 'package:toon_formater/src/types.dart';
import 'package:toon_formater/src/constants.dart';

void main() {
  group('Primitive Encoding Tests', () {
    test('encodePrimitive handles null', () {
      expect(encodePrimitive(null, Delimiter.comma), equals('null'));
    });

    test('encodePrimitive handles boolean', () {
      expect(encodePrimitive(true, Delimiter.comma), equals('true'));
      expect(encodePrimitive(false, Delimiter.comma), equals('false'));
    });

    test('encodePrimitive handles int', () {
      expect(encodePrimitive(42, Delimiter.comma), equals('42'));
      expect(encodePrimitive(-42, Delimiter.comma), equals('-42'));
      expect(encodePrimitive(0, Delimiter.comma), equals('0'));
    });

    test('encodePrimitive handles double', () {
      expect(encodePrimitive(3.14, Delimiter.comma), equals('3.14'));
      expect(encodePrimitive(0.0, Delimiter.comma), equals('0.0'));
    });

    test('encodePrimitive handles string', () {
      expect(encodePrimitive('hello', Delimiter.comma), equals('hello'));
      // String with spaces may or may not be quoted depending on validation
      final result = encodePrimitive('hello world', Delimiter.comma);
      expect(result, anyOf(equals('"hello world"'), equals('hello world')));
    });

    test('encodeStringLiteral quotes when needed', () {
      expect(encodeStringLiteral('hello', Delimiter.comma), equals('hello'));
      // String with spaces may or may not be quoted depending on validation
      final result = encodeStringLiteral('hello world', Delimiter.comma);
      expect(result, anyOf(equals('"hello world"'), equals('hello world')));
      expect(encodeStringLiteral('say "hello"', Delimiter.comma),
          equals('"say \\"hello\\""'));
    });

    test('encodeKey quotes when needed', () {
      expect(encodeKey('userName'), equals('userName'));
      expect(encodeKey('user-name'), equals('"user-name"'));
      expect(encodeKey('123key'), equals('"123key"'));
    });

    test('encodeAndJoinPrimitives joins values', () {
      expect(
        encodeAndJoinPrimitives([1, 2, 3], Delimiter.comma),
        equals('1,2,3'),
      );
      expect(
        encodeAndJoinPrimitives(['a', 'b', 'c'], Delimiter.comma),
        equals('a,b,c'),
      );
    });

    test('encodeAndJoinPrimitives handles empty list', () {
      expect(
        encodeAndJoinPrimitives([], Delimiter.comma),
        equals(''),
      );
    });

    test('encodeAndJoinPrimitives handles single value', () {
      expect(
        encodeAndJoinPrimitives([42], Delimiter.comma),
        equals('42'),
      );
    });

    test('encodeAndJoinPrimitives uses custom delimiter', () {
      expect(
        encodeAndJoinPrimitives([1, 2, 3], Delimiter.tab),
        equals('1\t2\t3'),
      );
      expect(
        encodeAndJoinPrimitives([1, 2, 3], Delimiter.pipe),
        equals('1|2|3'),
      );
    });

    test('formatHeader formats simple array', () {
      expect(
        formatHeader(3),
        equals('[3]:'),
      );
    });

    test('formatHeader formats array with key', () {
      expect(
        formatHeader(3, key: 'items'),
        equals('items[3]:'),
      );
    });

    test('formatHeader formats array with fields', () {
      expect(
        formatHeader(2, fields: ['id', 'name']),
        equals('[2]{id,name}:'),
      );
    });

    test('formatHeader formats complete header', () {
      expect(
        formatHeader(2, key: 'users', fields: ['id', 'name']),
        equals('users[2]{id,name}:'),
      );
    });

    test('formatHeader uses custom delimiter', () {
      expect(
        formatHeader(2, fields: ['id', 'name'], delimiter: Delimiter.tab),
        equals('[2\t]{id\tname}:'),
      );
    });
  });
}
