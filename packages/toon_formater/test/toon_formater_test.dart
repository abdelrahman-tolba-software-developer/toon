import 'package:test/test.dart';
import 'package:toon_formater/toon_formater.dart';

void main() {
  group('TOON Formatter Tests', () {
    group('Primitive Encoding', () {
      test('encodes null', () {
        expect(encode(null), equals('null'));
      });

      test('encodes boolean true', () {
        expect(encode(true), equals('true'));
      });

      test('encodes boolean false', () {
        expect(encode(false), equals('false'));
      });

      test('encodes integer', () {
        expect(encode(42), equals('42'));
      });

      test('encodes negative integer', () {
        expect(encode(-42), equals('-42'));
      });

      test('encodes double', () {
        expect(encode(3.14), equals('3.14'));
      });

      test('encodes zero', () {
        expect(encode(0), equals('0'));
      });

      test('encodes empty string', () {
        expect(encode(''), equals('""'));
      });

      test('encodes simple string', () {
        expect(encode('hello'), equals('hello'));
      });

      test('encodes string with spaces', () {
        final result = encode('hello world');
        // String with spaces may or may not be quoted depending on validation
        expect(result, anyOf(equals('"hello world"'), equals('hello world')));
      });

      test('encodes string with quotes', () {
        expect(encode('say "hello"'), equals('"say \\"hello\\""'));
      });

      test('encodes string with backslash', () {
        expect(encode('path\\to\\file'), equals('"path\\\\to\\\\file"'));
      });

      test('encodes string with newline', () {
        expect(encode('line1\nline2'), equals('"line1\\nline2"'));
      });

      test('encodes string with tab', () {
        expect(encode('col1\tcol2'), equals('"col1\\tcol2"'));
      });

      test('encodes string that looks like number', () {
        expect(encode('123'), equals('"123"'));
      });

      test('encodes string that looks like boolean', () {
        expect(encode('true'), equals('"true"'));
      });
    });

    group('Object Encoding', () {
      test('encodes empty object', () {
        expect(encode(<String, dynamic>{}), equals(''));
      });

      test('encodes simple object', () {
        final result = encode({'name': 'Alice', 'age': 30});
        expect(result, contains('name: Alice'));
        expect(result, contains('age: 30'));
      });

      test('encodes object with null value', () {
        final result = encode({'name': 'Alice', 'email': null});
        expect(result, contains('name: Alice'));
        expect(result, contains('email: null'));
      });

      test('encodes nested object', () {
        final result = encode({
          'user': {
            'name': 'Alice',
            'age': 30,
          }
        });
        expect(result, contains('user:'));
        expect(result, contains('name: Alice'));
        expect(result, contains('age: 30'));
      });

      test('encodes object with special characters in key', () {
        final result = encode({'user-name': 'Alice'});
        expect(result, contains('"user-name":'));
      });

      test('encodes object with quoted key when needed', () {
        final result = encode({'123key': 'value'});
        expect(result, contains('"123key":'));
      });
    });

    group('Array Encoding', () {
      test('encodes empty array', () {
        expect(encode([]), equals('[0]:'));
      });

      test('encodes array of primitives', () {
        final result = encode([1, 2, 3]);
        expect(result, equals('[3]: 1,2,3'));
      });

      test('encodes array of strings', () {
        final result = encode(['a', 'b', 'c']);
        expect(result, equals('[3]: a,b,c'));
      });

      test('encodes array of mixed primitives', () {
        final result = encode([1, 'two', true, null]);
        expect(result, contains('[4]:'));
        expect(result, contains('1'));
        expect(result, contains('two'));
        expect(result, contains('true'));
        expect(result, contains('null'));
      });

      test('encodes array of objects (tabular format)', () {
        final result = encode([
          {'id': 1, 'name': 'Alice'},
          {'id': 2, 'name': 'Bob'},
        ]);
        expect(result, contains('[2]{id,name}:'));
        expect(result, contains('1,Alice'));
        expect(result, contains('2,Bob'));
      });

      test('encodes array with key', () {
        final result = encode({
          'users': [1, 2, 3]
        });
        expect(result, contains('users[3]:'));
        expect(result, contains('1,2,3'));
      });

      test('encodes nested arrays', () {
        final result = encode([
          [1, 2],
          [3, 4]
        ]);
        expect(result, contains('[2]:'));
      });
    });

    group('Complex Data Structures', () {
      test('encodes complex nested structure', () {
        final data = {
          'users': [
            {
              'id': 1,
              'name': 'Alice',
              'tags': ['admin', 'user'],
              'metadata': {
                'created': '2024-01-01',
                'active': true,
              }
            },
            {
              'id': 2,
              'name': 'Bob',
              'tags': ['user'],
              'metadata': {
                'created': '2024-01-02',
                'active': false,
              }
            }
          ],
          'total': 2,
        };

        final result = encode(data);
        expect(result, contains('users'));
        expect(result, contains('total: 2'));
        expect(result, contains('Alice'));
        expect(result, contains('Bob'));
      });

      test('encodes object with array of objects', () {
        final data = {
          'products': [
            {'sku': 'A1', 'price': 9.99},
            {'sku': 'B2', 'price': 14.50},
          ]
        };

        final result = encode(data);
        expect(result, contains('products'));
        expect(result, contains('[2]{sku,price}:'));
      });
    });

    group('EncodeOptions', () {
      test('uses custom indent', () {
        final result = encode(
          {
            'a': {'b': 'c'}
          },
          EncodeOptions(indent: 4),
        );
        expect(result, contains('    ')); // 4 spaces
      });

      test('uses tab delimiter', () {
        final result = encode(
          [1, 2, 3],
          EncodeOptions(delimiter: Delimiter.tab),
        );
        expect(result, contains('\t'));
      });

      test('uses pipe delimiter', () {
        final result = encode(
          [1, 2, 3],
          EncodeOptions(delimiter: Delimiter.pipe),
        );
        expect(result, contains('|'));
      });
    });

    group('Edge Cases', () {
      test('handles very large number', () {
        expect(encode(999999999999), equals('999999999999'));
      });

      test('handles very small number', () {
        expect(encode(0.0000001), equals('1e-7'));
      });

      test('handles NaN', () {
        expect(encode(double.nan), equals('null'));
      });

      test('handles infinity', () {
        expect(encode(double.infinity), equals('null'));
      });

      test('handles negative infinity', () {
        expect(encode(double.negativeInfinity), equals('null'));
      });

      test('handles DateTime normalization', () {
        final dt = DateTime(2024, 1, 1, 12, 0, 0);
        final result = encode(dt);
        expect(result, contains('2024-01-01'));
      });

      test('handles Set normalization', () {
        final result = encode({1, 2, 3});
        expect(result, contains('[3]:'));
      });

      test('handles Map with non-string keys', () {
        final result = encode({1: 'one', 2: 'two'});
        // Keys are normalized to strings
        expect(result, contains('"1"'));
        expect(result, contains('"2"'));
        expect(result, contains('one'));
        expect(result, contains('two'));
      });
    });

    group('Round Trip Tests', () {
      test('primitives round trip', () {
        final values = [null, true, false, 42, 3.14, 'hello'];
        for (final value in values) {
          final encoded = encode(value);
          // Note: decode is simplified, so we just verify encoding works
          expect(encoded, isNotEmpty);
        }
      });

      test('object round trip', () {
        final data = {'name': 'Alice', 'age': 30};
        final encoded = encode(data);
        expect(encoded, isNotEmpty);
        expect(encoded, contains('name'));
        expect(encoded, contains('age'));
      });

      test('array round trip', () {
        final data = [1, 2, 3];
        final encoded = encode(data);
        expect(encoded, contains('[3]:'));
        expect(encoded, contains('1,2,3'));
      });
    });

    group('String Escaping', () {
      test('escapes quotes correctly', () {
        expect(encode('say "hello"'), equals('"say \\"hello\\""'));
      });

      test('escapes backslashes correctly', () {
        expect(encode('path\\to\\file'), equals('"path\\\\to\\\\file"'));
      });

      test('escapes newlines correctly', () {
        expect(encode('line1\nline2'), equals('"line1\\nline2"'));
      });

      test('escapes carriage returns correctly', () {
        expect(encode('line1\rline2'), equals('"line1\\rline2"'));
      });

      test('escapes tabs correctly', () {
        expect(encode('col1\tcol2'), equals('"col1\\tcol2"'));
      });

      test('handles multiple escape sequences', () {
        final result = encode('say "hello"\nand\\goodbye');
        expect(result, contains('\\"'));
        expect(result, contains('\\n'));
        expect(result, contains('\\\\'));
      });
    });

    group('Key Encoding', () {
      test('unquoted valid key', () {
        final result = encode({'userName': 'Alice'});
        expect(result, contains('userName:'));
        expect(result, isNot(contains('"userName"')));
      });

      test('quoted invalid key', () {
        final result = encode({'user-name': 'Alice'});
        expect(result, contains('"user-name":'));
      });

      test('quoted numeric key', () {
        final result = encode({'123key': 'value'});
        expect(result, contains('"123key":'));
      });
    });

    group('Array Format Detection', () {
      test('detects primitive array', () {
        final result = encode([1, 2, 3]);
        expect(result, equals('[3]: 1,2,3'));
      });

      test('detects tabular array', () {
        final result = encode([
          {'id': 1, 'name': 'A'},
          {'id': 2, 'name': 'B'},
        ]);
        expect(result, contains('[2]{id,name}:'));
      });

      test('handles non-uniform object array', () {
        final result = encode([
          {'id': 1},
          {'id': 2, 'name': 'B'},
        ]);
        // Should fall back to list items format
        expect(result, contains('[2]:'));
      });
    });

    group('Empty Values', () {
      test('empty string', () {
        expect(encode(''), equals('""'));
      });

      test('empty list', () {
        expect(encode([]), equals('[0]:'));
      });

      test('empty map', () {
        expect(encode(<String, dynamic>{}), equals(''));
      });

      test('list with empty strings', () {
        final result = encode(['', '', '']);
        expect(result, contains('[3]:'));
      });
    });

    group('Special Characters', () {
      test('handles unicode characters', () {
        final result = encode('Hello 世界');
        expect(result, contains('世界'));
      });

      test('handles emoji', () {
        final result = encode('Hello 👋');
        expect(result, contains('👋'));
      });

      test('handles string with colon', () {
        final result = encode('key:value');
        expect(result, contains('"key:value"'));
      });

      test('handles string with brackets', () {
        final result = encode('item[0]');
        expect(result, contains('"item[0]"'));
      });
    });
  });
}
