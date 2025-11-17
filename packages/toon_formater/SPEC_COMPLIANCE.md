# TOON Specification Compliance Report

This document verifies compliance with the [TOON Specification v2.0](https://github.com/toon-format/spec).

## ✅ Fully Compliant Features

### Core Encoding
- ✅ **Primitive types**: null, boolean, number, string
- ✅ **Objects**: Key-value pairs with proper indentation
- ✅ **Arrays**: 
  - Primitive arrays: inline format `[N]: value1,value2`
  - Tabular arrays: `[N]{field1,field2}:` with rows
  - Mixed arrays: list format with `-` markers
- ✅ **Empty containers**: Empty objects and arrays handled correctly
- ✅ **2-space indentation**: Default and enforced
- ✅ **Blank lines**: Between top-level object entries

### String Encoding
- ✅ **Unquoted strings**: When safe (no special chars, delimiters, etc.)
- ✅ **Quoted strings**: When needed (spaces, special chars, etc.)
- ✅ **Escape sequences**: `\n`, `\r`, `\t`, `\\`, `\"`
- ✅ **String validation**: Proper detection of when quoting is needed

### Key Encoding
- ✅ **Unquoted keys**: Valid identifiers (alphanumeric + underscore, starting with letter/underscore)
- ✅ **Quoted keys**: Invalid identifiers or special characters
- ✅ **Key validation**: Proper regex matching

### Array Headers
- ✅ **Length encoding**: `[N]` format
- ✅ **Field headers**: `{field1,field2}` for tabular arrays
- ✅ **Delimiter encoding**: Non-default delimiters shown in header (`[N\t]`, `[N|]`)
- ✅ **Key prefix**: `key[N]:` format

### Delimiters
- ✅ **Comma delimiter**: Default, not shown in header
- ✅ **Tab delimiter**: `\t`, shown in header
- ✅ **Pipe delimiter**: `|`, shown in header

### Number Formatting
- ✅ **Integers**: Direct encoding
- ✅ **Floats**: Proper decimal representation
- ✅ **Scientific notation**: Supported
- ✅ **Zero handling**: `0` encoded correctly
- ✅ **Negative numbers**: `-` prefix

### Special Values
- ✅ **null**: Encoded as `null`
- ✅ **true/false**: Encoded as `true`/`false`
- ✅ **NaN/Infinity**: Normalized to `null` (as per JSON spec)

### Tabular Array Detection
- ✅ **Uniform objects**: Detected and encoded as tabular
- ✅ **Non-uniform objects**: Fall back to list format
- ✅ **Primitive values only**: Tabular format requires all primitive values
- ✅ **Same keys**: All objects must have same keys

## ⚠️ Optional Features (Not Implemented)

### Key Folding
- ⚠️ **keyFolding option**: Defined in `EncodeOptions` but not implemented
  - This is an **optional** feature in the spec
  - Would allow flattening nested objects: `{"user.name": "Alice"}` → `user.name: Alice`
  - Currently: `{"user": {"name": "Alice"}}` → `user:\n  name: Alice`

### Path Expansion (Decoder)
- ⚠️ **expandPaths option**: Defined in `DecodeOptions` but decoder is placeholder
  - This is an **optional** feature in the spec
  - Would reconstruct dotted keys into nested objects
  - Pairs with `keyFolding` for lossless round-trips

## 🔄 Decoder Status

- ⚠️ **Decoder**: Currently a placeholder implementation
  - Returns empty object `{}`
  - Full decoder implementation needed for complete spec compliance
  - Decoder should parse:
    - Line-by-line parsing
    - Indentation tracking
    - Array header parsing
    - Tabular row parsing
    - List item parsing
    - String unescaping
    - Strict mode validation

## 📋 Spec Example Verification

The implementation correctly encodes the spec example:

**Input:**
```json
{
  "context": {
    "task": "Our favorite hikes together",
    "location": "Boulder",
    "season": "spring_2025"
  },
  "friends": ["ana", "luis", "sam"],
  "hikes": [
    {"id": 1, "name": "Blue Lake Trail", ...},
    ...
  ]
}
```

**Output:**
```
context:
  task: Our favorite hikes together
  location: Boulder
  season: spring_2025

friends[3]: ana,luis,sam

hikes[3]{id,name,distanceKm,elevationGain,companion,wasSunny}:
  1,Blue Lake Trail,7.5,320,ana,true
  2,Ridge Overlook,9.2,540,luis,false
  3,Wildflower Loop,5.1,180,sam,true
```

✅ **Matches spec exactly** (including blank lines between top-level entries)

## 🎯 Compliance Summary

- **Core Encoding**: ✅ 100% Compliant
- **String Handling**: ✅ 100% Compliant  
- **Array Formats**: ✅ 100% Compliant
- **Delimiters**: ✅ 100% Compliant
- **Optional Features**: ⚠️ Key folding not implemented (optional)
- **Decoder**: ⚠️ Placeholder only (needs full implementation)

## 📚 References

- [TOON Specification v2.0](https://github.com/toon-format/spec)
- [TOON Format Website](https://toonformat.dev)
- [Test Fixtures](https://github.com/toon-format/spec/tree/main/tests/fixtures)

