# Toon.jl

A Julia implementation of the TOON (Token-Oriented Object Notation) format - a compact, deterministic JSON format for LLM prompts.

## Installation

```julia
using Pkg
Pkg.add(url="https://github.com/toon-format/toon_julia")
```

Or add to your `Project.toml`:

```toml
[deps]
Toon = { git = "https://github.com/toon-format/toon_julia" }
```

## Usage

### Encoding

```julia
using Toon

# Encode a dictionary
nested = Dict(
    "context" => Dict(
        "task" => "Our favorite hikes together",
        "location" => "Boulder",
        "season" => "spring_2025"
    ),
    "friends" => ["ana", "luis", "sam"],
    "hikes" => [
        Dict(
            "id" => 1,
            "name" => "Blue Lake Trail",
            "distanceKm" => 7.5,
            "elevationGain" => 320,
            "companion" => "ana",
            "wasSunny" => true
        ),
        Dict(
            "id" => 2,
            "name" => "Ridge Overlook",
            "distanceKm" => 9.2,
            "elevationGain" => 540,
            "companion" => "luis",
            "wasSunny" => false
        ),
        Dict(
            "id" => 3,
            "name" => "Wildflower Loop",
            "distanceKm" => 5.1,
            "elevationGain" => 180,
            "companion" => "sam",
            "wasSunny" => true
        )
    ]
)

context:
  task: Our favorite hikes together
  location: Boulder
  season: spring_2025
friends[3]: ana,luis,sam
hikes[3]{id,name,distanceKm,elevationGain,companion,wasSunny}:
  1,Blue Lake Trail,7.5,320,ana,true
  2,Ridge Overlook,9.2,540,luis,false
  3,Wildflower Loop,5.1,180,sam,true

data = Dict("name" => "Alice", "age" => 30)
toon_string = toonEncode(data)
# name: Alice
# age: 30

# Encode with options
options = EncodeOptions(indent=4, delimiter=',')
toon_string = toonEncode(data; options=options)

# Encode arrays
users = [Dict("id" => 1, "name" => "Alice"), Dict("id" => 2, "name" => "Bob")]
toon_string = toonEncode(Dict("users" => users))
# users[2]:
#   - id: 1
#   - name: Alice
#   - id: 2
#   - name: Bob
```

### Decoding

```julia
using Toon

# Decode a TOON string
toon_string = "name: Alice\nage: 30"
data = toonDecode(toon_string)
# Dict{String, Any}("name" => "Alice", "age" => 30)

# Decode with options
options = DecodeOptions(strict=true, expand_paths=:safe)
data = toonDecode(toon_string; options=options)
```

## Features

- **Full TOON 2.0 specification support**
- **Encoding**: Convert Julia values (Dict, Array, primitives) to TOON format
- **Decoding**: Parse TOON strings back to Julia values
- **Configurable options**: Indentation, delimiters, strict mode, path expansion
- **Type-safe**: Uses Julia's type system for JSON value types

## Options

### EncodeOptions

- `indent::Int` - Number of spaces per indentation level (default: 2)
- `delimiter::Char` - Delimiter for tabular arrays (default: ',')
- `key_folding::Symbol` - Enable key folding (`:off` or `:safe`, default: `:off`)
- `flatten_depth::Int` - Maximum depth for key folding (default: `typemax(Int)`)

### DecodeOptions

- `indent::Int` - Number of spaces per indentation level (default: 2)
- `strict::Bool` - Enforce strict validation (default: `true`)
- `expand_paths::Symbol` - Enable path expansion (`:off` or `:safe`, default: `:off`)

## Examples

See the [TOON specification](https://github.com/toon-format/spec) for more examples and details about the format.

## License

MIT License - see LICENSE file for details.

