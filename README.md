# Sui Coverage Demo

A demo repository showing how to analyze Sui Move test coverage and identify gaps.

## Quick Start

```bash
# 1. Run tests with coverage
cd demo_package
sui move test --coverage --trace

# 2. Generate LCOV report
sui move coverage lcov

# 3. Analyze coverage (filter to just our package)
python3 analyze.py lcov.info -f "demo_package" -s sources/
```

## Example Output

```
============================================================
SUI MOVE COVERAGE ANALYSIS
============================================================

Files analyzed: 1
Function coverage: 8/12
Line coverage: 36/48 (75.0%)
Branch coverage: 14/28 (50.0%)

────────────────────────────────────────────────────────────
📄 sources/counter.move
   Lines: 36/48, Branches: 14/28, Functions: 8/12

   ⚠️  Uncalled functions:
      - decrement (line 33)
      - increment_by (line 59)
      - is_at_max (line 49)
      - reset (line 39)

   ⚠️  Untaken branches:
      - Line 18: 1 branch(es) not taken
      - Line 28: 1 branch(es) not taken
      - Line 34: 3 branch(es) not taken
      ...

   💡 Suggestions:
      1. 🔴 Write a test that calls `decrement()`
      2. 🔴 Write a test that calls `increment_by()`
      3. 🔴 Write a test that calls `is_at_max()`
      4. 🔴 Write a test that calls `reset()`
      5. 🟡 Add test case to cover alternate branch at line 18
         └─ assert!(max_value > 0, EInvalidMaxValue);
      ...
```

## Priority Levels

- 🔴 **High**: Uncalled functions - entire functions never executed
- 🟡 **Medium**: Untaken branches - conditional paths not covered
- 🟢 **Low**: Uncovered line ranges

## CLI Options

| Option | Short | Description |
|--------|-------|-------------|
| `--source-dir` | `-s` | Directory with .move sources for context snippets |
| `--filter` | `-f` | Only show files matching this path pattern |
| `--issues-only` | `-i` | Only show files with coverage issues |
| `--json` | `-j` | Output as JSON instead of human-readable |

## The Demo Package

The `demo_package/sources/counter.move` module intentionally has incomplete test coverage:

**Tested:**
- `new()` - creating counters
- `increment()` - incrementing
- `is_at_zero()` - checking if zero
- `value()` - getting value
- `destroy()` - cleanup

**Not tested:**
- `decrement()` - never called
- `reset()` - never called
- `is_at_max()` - never called
- `increment_by()` - never called
- Error paths (assertions that should fail)

## Requirements

- Sui CLI (`sui move test --coverage --trace`)
- Python 3.10+
