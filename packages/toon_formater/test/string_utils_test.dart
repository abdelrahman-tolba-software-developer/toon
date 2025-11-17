import 'package:test/test.dart';
import 'package:toon_formater/src/string_utils.dart';
import 'package:toon_formater/src/constants.dart';

void main() {
  group('String Utils Tests', () {
    group('escapeString', () {
      test('escapes backslash', () {
        expect(escapeString('path\\to\\file'), equals('path\\\\to\\\\file'));
      });

      test('escapes double quote', () {
        expect(escapeString('say "hello"'), equals('say \\"hello\\"'));
      });

      test('escapes newline', () {
        expect(escapeString('line1\nline2'), equals('line1\\nline2'));
      });

      test('escapes carriage return', () {
        expect(escapeString('line1\rline2'), equals('line1\\rline2'));
      });

      test('escapes tab', () {
        expect(escapeString('col1\tcol2'), equals('col1\\tcol2'));
      });

      test('handles multiple escape sequences', () {
        final result = escapeString('say "hello"\nand\\goodbye');
        expect(result, contains('\\"'));
        expect(result, contains('\\n'));
        expect(result, contains('\\\\'));
      });

      test('handles string without escapes', () {
        expect(escapeString('hello'), equals('hello'));
      });

      test('handles empty string', () {
        expect(escapeString(''), equals(''));
      });
    });

    group('unescapeString', () {
      test('unescapes backslash', () {
        expect(unescapeString('path\\\\to\\\\file'), equals('path\\to\\file'));
      });

      test('unescapes double quote', () {
        expect(unescapeString('say \\"hello\\"'), equals('say "hello"'));
      });

      test('unescapes newline', () {
        expect(unescapeString('line1\\nline2'), equals('line1\nline2'));
      });

      test('unescapes carriage return', () {
        expect(unescapeString('line1\\rline2'), equals('line1\rline2'));
      });

      test('unescapes tab', () {
        expect(unescapeString('col1\\tcol2'), equals('col1\tcol2'));
      });

      test('handles multiple escape sequences', () {
        final result = unescapeString('say \\"hello\\"\\nand\\\\goodbye');
        expect(result, contains('"'));
        expect(result, contains('\n'));
        expect(result, contains('\\'));
      });

      test('handles string without escapes', () {
        expect(unescapeString('hello'), equals('hello'));
      });

      test('throws on invalid escape sequence', () {
        expect(() => unescapeString('hello\\x'), throwsFormatException);
      });

      test('throws on backslash at end', () {
        expect(() => unescapeString('hello\\'), throwsFormatException);
      });
    });

    group('findClosingQuote', () {
      test('finds closing quote', () {
        expect(findClosingQuote('"hello"', 0), equals(6));
      });

      test('handles escaped quotes', () {
        expect(findClosingQuote('"say \\"hello\\""', 0), equals(14));
      });

      test('returns -1 if not found', () {
        expect(findClosingQuote('"hello', 0), equals(-1));
      });

      test('handles empty quoted string', () {
        expect(findClosingQuote('""', 0), equals(1));
      });
    });

    group('findUnquotedChar', () {
      test('finds char outside quotes', () {
        expect(findUnquotedChar('key:value', ':', 0), equals(3));
      });

      test('ignores char inside quotes', () {
        expect(findUnquotedChar('"key:value":other', ':', 0), equals(11));
      });

      test('handles escaped quotes', () {
        expect(findUnquotedChar('"say \\"hello\\"":value', ':', 0), equals(15));
      });

      test('returns -1 if not found', () {
        expect(findUnquotedChar('keyvalue', ':', 0), equals(-1));
      });

      test('starts from given index', () {
        expect(findUnquotedChar('a:b:c', ':', 2), equals(3));
      });
    });
  });
}
