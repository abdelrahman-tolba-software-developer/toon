import 'package:test/test.dart';
import 'package:toon_formater/src/validation.dart';
import 'package:toon_formater/src/constants.dart';

void main() {
  group('Validation Tests', () {
    group('isValidUnquotedKey', () {
      test('validates simple key', () {
        expect(isValidUnquotedKey('userName'), isTrue);
        expect(isValidUnquotedKey('User_Name'), isTrue);
        expect(isValidUnquotedKey('_private'), isTrue);
      });

      test('rejects key starting with number', () {
        expect(isValidUnquotedKey('123key'), isFalse);
      });

      test('rejects key with hyphen', () {
        expect(isValidUnquotedKey('user-name'), isFalse);
      });

      test('rejects key with spaces', () {
        expect(isValidUnquotedKey('user name'), isFalse);
      });

      test('rejects empty key', () {
        expect(isValidUnquotedKey(''), isFalse);
      });
    });

    group('isSafeUnquoted', () {
      test('allows simple string', () {
        expect(isSafeUnquoted('hello', ','), isTrue);
      });

      test('rejects empty string', () {
        expect(isSafeUnquoted('', ','), isFalse);
      });

      test('rejects string with leading/trailing spaces', () {
        expect(isSafeUnquoted(' hello', ','), isFalse);
        expect(isSafeUnquoted('hello ', ','), isFalse);
      });

      test('rejects boolean-like string', () {
        expect(isSafeUnquoted('true', ','), isFalse);
        expect(isSafeUnquoted('false', ','), isFalse);
        expect(isSafeUnquoted('null', ','), isFalse);
      });

      test('rejects numeric-like string', () {
        expect(isSafeUnquoted('123', ','), isFalse);
        expect(isSafeUnquoted('3.14', ','), isFalse);
      });

      test('rejects string with colon', () {
        expect(isSafeUnquoted('key:value', ','), isFalse);
      });

      test('rejects string with quotes', () {
        expect(isSafeUnquoted('say "hello"', ','), isFalse);
      });

      test('rejects string with backslash', () {
        expect(isSafeUnquoted('path\\to', ','), isFalse);
      });

      test('rejects string with brackets', () {
        expect(isSafeUnquoted('item[0]', ','), isFalse);
        expect(isSafeUnquoted('{key}', ','), isFalse);
      });

      test('rejects string with control characters', () {
        expect(isSafeUnquoted('line1\nline2', ','), isFalse);
        expect(isSafeUnquoted('col1\tcol2', ','), isFalse);
      });

      test('rejects string with delimiter', () {
        expect(isSafeUnquoted('a,b', ','), isFalse);
        expect(isSafeUnquoted('a\tb', '\t'), isFalse);
      });

      test('rejects string starting with list marker', () {
        expect(isSafeUnquoted('-item', ','), isFalse);
      });

      test('allows unicode characters', () {
        expect(isSafeUnquoted('Hello世界', ','), isTrue);
      });

      test('allows emoji', () {
        expect(isSafeUnquoted('Hello👋', ','), isTrue);
      });
    });

    group('isIdentifierSegment', () {
      test('validates identifier', () {
        expect(isIdentifierSegment('userName'), isTrue);
        expect(isIdentifierSegment('User_Name'), isTrue);
        expect(isIdentifierSegment('_private'), isTrue);
      });

      test('rejects identifier with dot', () {
        expect(isIdentifierSegment('user.name'), isFalse);
      });

      test('rejects identifier starting with number', () {
        expect(isIdentifierSegment('123key'), isFalse);
      });
    });
  });
}
