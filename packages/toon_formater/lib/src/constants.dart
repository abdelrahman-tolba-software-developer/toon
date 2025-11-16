// List markers
const String listItemMarker = '-';
const String listItemPrefix = '- ';

// Structural characters
const String comma = ',';
const String colon = ':';
const String space = ' ';
const String pipe = '|';
const String dot = '.';

// Brackets and braces
const String openBracket = '[';
const String closeBracket = ']';
const String openBrace = '{';
const String closeBrace = '}';

// Literals
const String nullLiteral = 'null';
const String trueLiteral = 'true';
const String falseLiteral = 'false';

// Escape characters
const String backslash = r'\';
const String doubleQuote = '"';
const String newline = '\n';
const String carriageReturn = '\r';
const String tab = '\t';

// Delimiters
enum Delimiter {
  comma(','),
  tab('\t'),
  pipe('|');

  const Delimiter(this.value);
  final String value;
}

const Delimiter defaultDelimiter = Delimiter.comma;

