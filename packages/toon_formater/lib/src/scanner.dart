import 'constants.dart';
import 'types.dart';

class ScanResult {
  final List<ParsedLine> lines;
  final List<BlankLineInfo> blankLines;

  ScanResult({required this.lines, required this.blankLines});
}

class LineCursor {
  final List<ParsedLine> _lines;
  int _index = 0;
  final List<BlankLineInfo> _blankLines;

  LineCursor(this._lines, [List<BlankLineInfo>? blankLines])
      : _blankLines = blankLines ?? [];

  List<BlankLineInfo> getBlankLines() => _blankLines;

  ParsedLine? peek() {
    if (_index >= _lines.length) return null;
    return _lines[_index];
  }

  ParsedLine? next() {
    if (_index >= _lines.length) return null;
    return _lines[_index++];
  }

  ParsedLine? current() {
    if (_index == 0) return null;
    return _lines[_index - 1];
  }

  void advance() {
    _index++;
  }

  bool atEnd() => _index >= _lines.length;

  int get length => _lines.length;
}

ScanResult toParsedLines(String source, int indentSize, bool strict) {
  if (source.trim().isEmpty) {
    return ScanResult(lines: [], blankLines: []);
  }

  final lines = source.split('\n');
  final parsed = <ParsedLine>[];
  final blankLines = <BlankLineInfo>[];

  for (int i = 0; i < lines.length; i++) {
    final raw = lines[i];
    final lineNumber = i + 1;
    int indent = 0;
    while (indent < raw.length && raw[indent] == space) {
      indent++;
    }

    final content = raw.substring(indent);

    // Track blank lines
    if (content.trim().isEmpty) {
      final depth = _computeDepthFromIndent(indent, indentSize);
      blankLines.add(BlankLineInfo(
        lineNumber: lineNumber,
        indent: indent,
        depth: depth,
      ));
      continue;
    }

    final depth = _computeDepthFromIndent(indent, indentSize);

    // Strict mode validation
    if (strict) {
      // Check for tabs in leading whitespace
      if (raw.substring(0, indent).contains(tab)) {
        throw FormatException(
          'Line $lineNumber: Tabs are not allowed in indentation in strict mode',
        );
      }

      // Check for exact multiples of indentSize
      if (indent > 0 && indent % indentSize != 0) {
        throw FormatException(
          'Line $lineNumber: Indentation must be exact multiple of $indentSize, but found $indent spaces',
        );
      }
    }

    parsed.add(ParsedLine(
      raw: raw,
      indent: indent,
      content: content,
      depth: depth,
      lineNumber: lineNumber,
    ));
  }

  return ScanResult(lines: parsed, blankLines: blankLines);
}

int _computeDepthFromIndent(int indentSpaces, int indentSize) {
  return indentSpaces ~/ indentSize;
}

