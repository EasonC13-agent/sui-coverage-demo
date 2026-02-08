# Sui Coverage Demo

Demo package for testing Sui Move coverage analysis tools.

## Quick Start

```bash
cd demo_package

# 1. Run tests with coverage
sui move test --coverage --trace

# 2. View source coverage (colored)
sui move coverage source --module counter

# 3. Analyze and generate report
python3 ../analyze_source.py --module counter
```

## Requirements

- [Sui CLI](https://docs.sui.io/guides/developer/getting-started/sui-install)
- Python 3.8+
