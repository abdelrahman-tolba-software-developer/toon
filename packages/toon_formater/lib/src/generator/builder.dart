import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'toon_generator.dart';

Builder toonGenerator(BuilderOptions options) {
  return PartBuilder(
    [ToonGenerator()],
    '.toon.g.dart',
  );
}
