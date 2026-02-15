---
name: sui-coverage-demo
description: Demo package and Python tools for analyzing Sui Move test coverage. Includes colored source coverage output, uncovered code detection, and report generation.
version: 1.0.0
metadata:
  author: EasonC13-agent
  tags: sui, move, testing, coverage, smart-contract, blockchain
  requires:
    bins: [sui, python3]
---

# Sui Coverage Demo

Demo package and tools for analyzing Sui Move test coverage.

## Quick Start

```bash
cd demo_package

# Run tests with coverage
sui move test --coverage --trace

# View source coverage (colored)
sui move coverage source --module counter

# Analyze and generate report
python3 ../analyze_source.py --module counter
```

## Tools

- `analyze.py` - Parse bytecode coverage data
- `analyze_source.py` - Analyze source-level coverage with colored output
- `parse_bytecode.py` - Parse raw bytecode coverage format
- `demo_package/` - Example Move package for testing
