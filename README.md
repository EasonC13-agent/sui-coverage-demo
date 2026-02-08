# Sui Coverage Tools

Tools for analyzing Sui Move test coverage and identifying untested code.

## Quick Start

```bash
git clone https://github.com/EasonC13-agent/sui-coverage-demo.git
cd sui-coverage-demo/demo_package

# Run tests with coverage
sui move test --coverage --trace

# Analyze source coverage (recommended)
python3 ../analyze_source.py --module counter --output coverage.md
```

## Tools Overview

| Tool | Purpose | Best For |
|------|---------|----------|
| `analyze_source.py` | Parse colored source coverage | **Precise line-by-line analysis** |
| `analyze.py` | Parse LCOV format | Overall statistics |
| `parse_bytecode.py` | Parse bytecode coverage | Low-level instruction analysis |

---

## 1. analyze_source.py (Recommended)

Analyzes source code coverage with precise identification of uncovered code segments.

### Usage

```bash
python3 analyze_source.py --module <module_name> [options]
```

### Options

| Option | Short | Description |
|--------|-------|-------------|
| `--module` | `-m` | Module name to analyze (required) |
| `--path` | `-p` | Package path (default: current directory) |
| `--output` | `-o` | Output file path (e.g., `coverage.md`) |
| `--markdown` | `--md` | Output as Markdown to stdout |
| `--json` | `-j` | Output as JSON |
| `--help` | `-h` | Show help |

### Examples

```bash
# Basic analysis (console output)
python3 analyze_source.py -m counter

# Save as Markdown report
python3 analyze_source.py -m counter -o coverage.md

# JSON output for CI integration
python3 analyze_source.py -m counter --json > coverage.json

# Analyze module in different directory
python3 analyze_source.py -m my_module -p /path/to/package
```

### Output Example

```
📍 Line 19:
   assert!(max_value > 0, EInvalidMaxValue);
   └─ 🔴 Uncovered: "assert!(max_value > 0, EInvalidMaxValue)"

💡 SUGGESTIONS:
🧪 Test assertion failure paths:
   - Line 19: assert!(max_value > 0, EInvalidMaxValue)
     → Write a test where this assertion FAILS
```

---

## 2. analyze.py (LCOV Parser)

Parses LCOV format coverage data for overall statistics.

### Usage

```bash
# First generate LCOV data
sui move coverage lcov

# Then analyze
python3 analyze.py lcov.info [options]
```

### Options

| Option | Short | Description |
|--------|-------|-------------|
| `--source-dir` | `-s` | Directory with .move sources for context |
| `--filter` | `-f` | Only show files matching path pattern |
| `--issues-only` | `-i` | Only show files with coverage issues |
| `--json` | `-j` | Output as JSON |

### Examples

```bash
# Basic analysis
python3 analyze.py lcov.info

# Filter to your package only (excludes framework deps)
python3 analyze.py lcov.info -f "my_package"

# Show source context
python3 analyze.py lcov.info -f "my_package" -s sources/

# Only files with issues
python3 analyze.py lcov.info -f "my_package" -i
```

### Output Example

```
SUI MOVE COVERAGE ANALYSIS

Files analyzed: 1
Function coverage: 8/12
Line coverage: 36/48 (75.0%)
Branch coverage: 14/28 (50.0%)

📄 sources/counter.move
   ⚠️  Uncalled functions:
      - decrement (line 33)
      - reset (line 39)
```

---

## 3. parse_bytecode.py (Bytecode Parser)

Parses bytecode coverage for low-level instruction analysis.

### Usage

```bash
sui move coverage bytecode --module <name> | python3 parse_bytecode.py [--json]
```

### Examples

```bash
# Basic analysis
sui move coverage bytecode --module counter | python3 parse_bytecode.py

# JSON output
sui move coverage bytecode --module counter | python3 parse_bytecode.py --json
```

### Output Example

```
BYTECODE COVERAGE ANALYSIS

Total instructions: 53
Covered (green):    45 (84%)
Uncovered (red):    8 (15%)

FUNCTION BREAKDOWN
⚠️ new: 11/15 (73%)
✅ value: 4/4 (100%)

UNCOVERED INSTRUCTIONS (RED)
🔴 new():
   [7] LdConst[2](u64: 2)    ← Error code
   [8] Abort                  ← Failure path
```

---

## Workflow Example

```bash
cd your_move_package

# 1. Run tests with coverage enabled
sui move test --coverage --trace

# 2. Generate reports
sui move coverage lcov
python3 /path/to/analyze_source.py -m your_module -o coverage.md
python3 /path/to/analyze.py lcov.info -f "your_package" -s sources/

# 3. Review coverage.md and write missing tests
cat coverage.md
```

---

## CI Integration

### GitHub Actions Example

```yaml
- name: Run tests with coverage
  run: |
    cd my_package
    sui move test --coverage --trace
    sui move coverage lcov

- name: Analyze coverage
  run: |
    python3 analyze_source.py -m my_module --json > coverage.json
    python3 analyze.py lcov.info -f "my_package" --json >> coverage.json

- name: Upload coverage report
  uses: actions/upload-artifact@v3
  with:
    name: coverage-report
    path: coverage.json
```

---

## Requirements

- Python 3.8+
- Sui CLI with coverage support (`sui move test --coverage --trace`)

## License

MIT
