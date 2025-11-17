import 'package:test/test.dart';
import 'package:toon_formater/toon_formater.dart';

void main() {
  group('TOON Spec Compliance Tests', () {
    test('matches spec example output format', () {
      // Example from TOON spec: https://github.com/toon-format/spec
      final data = {
        'context': {
          'task': 'Our favorite hikes together',
          'location': 'Boulder',
          'season': 'spring_2025'
        },
        'friends': ['ana', 'luis', 'sam'],
        'hikes': [
          {
            'id': 1,
            'name': 'Blue Lake Trail',
            'distanceKm': 7.5,
            'elevationGain': 320,
            'companion': 'ana',
            'wasSunny': true
          },
          {
            'id': 2,
            'name': 'Ridge Overlook',
            'distanceKm': 9.2,
            'elevationGain': 540,
            'companion': 'luis',
            'wasSunny': false
          },
          {
            'id': 3,
            'name': 'Wildflower Loop',
            'distanceKm': 5.1,
            'elevationGain': 180,
            'companion': 'sam',
            'wasSunny': true
          }
        ]
      };

      final result = encode(data);

      // Verify structure matches spec
      expect(result, contains('context:'));
      expect(result, contains('task: Our favorite hikes together'));
      expect(result, contains('location: Boulder'));
      expect(result, contains('season: spring_2025'));

      // Verify blank line between top-level entries
      expect(result, contains('spring_2025\n\nfriends'));

      // Verify primitive array format
      expect(result, contains('friends[3]: ana,luis,sam'));

      // Verify blank line before hikes
      expect(result, contains('sam\n\nhikes'));

      // Verify tabular array format
      expect(
          result,
          contains(
              'hikes[3]{id,name,distanceKm,elevationGain,companion,wasSunny}:'));
      expect(result, contains('1,Blue Lake Trail,7.5,320,ana,true'));
      expect(result, contains('2,Ridge Overlook,9.2,540,luis,false'));
      expect(result, contains('3,Wildflower Loop,5.1,180,sam,true'));

      print('=== Spec Compliance Test Output ===');
      print(result);
      print('=== End ===');
    });

    test('verifies delimiter encoding in headers', () {
      final data = {
        'items': [
          {'sku': 'A1', 'qty': 2, 'price': 9.99},
          {'sku': 'B2', 'qty': 1, 'price': 14.5},
        ],
      };

      // Test comma delimiter (default - should not show delimiter in header)
      final commaResult =
          encode(data, EncodeOptions(delimiter: Delimiter.comma));
      expect(commaResult, contains('items[2]{sku,qty,price}:'));
      expect(commaResult, isNot(contains('items[2,]{')));

      // Test tab delimiter (should show delimiter in header)
      final tabResult = encode(data, EncodeOptions(delimiter: Delimiter.tab));
      expect(tabResult, contains('items[2\t]{sku\tqty\tprice}:'));

      // Test pipe delimiter (should show delimiter in header)
      final pipeResult = encode(data, EncodeOptions(delimiter: Delimiter.pipe));
      expect(pipeResult, contains('items[2|]{sku|qty|price}:'));
    });

    test('verifies 2-space indentation (spec requirement)', () {
      final data = {
        'nested': {
          'deep': {'value': 'test'}
        }
      };

      final result = encode(data);
      final lines = result.split('\n');

      // Verify indentation
      expect(lines[0], equals('nested:'));
      expect(lines[1], equals('  deep:'));
      expect(lines[2], equals('    value: test'));
    });

    test('verifies empty object encoding', () {
      expect(encode(<String, dynamic>{}), equals(''));
    });

    test('verifies empty array encoding', () {
      expect(encode([]), equals('[0]:'));
      expect(encode({'items': []}), contains('items[0]:'));
    });
  });
}
