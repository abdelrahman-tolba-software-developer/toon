import 'constants.dart';

class LineWriter {
  final List<String> _lines = [];
  final String _indentationString;

  LineWriter(int indentSize) : _indentationString = ' ' * indentSize;

  void push(int depth, String content) {
    if (depth == 0) {
      _lines.add(content);
      return;
    }
    // Build indentation string once and reuse
    final indent = _indentationString * depth;
    _lines.add(indent + content);
  }

  void pushListItem(int depth, String content) {
    if (depth == 0) {
      _lines.add('$listItemPrefix$content');
      return;
    }
    final indent = _indentationString * depth;
    _lines.add('$indent$listItemPrefix$content');
  }

  @override
  String toString() {
    return _lines.join('\n');
  }
}

