# Coverage Report: counter

🔴 **Found 21 uncovered code segment(s)**

## Uncovered Code

### Line 19

```move
assert!(max_value > 0, EInvalidMaxValue);
```

- ❌ **Uncovered:** `assert!(max_value > 0, EInvalidMaxValue)`

### Line 29

```move
assert!(counter.value < counter.max_value, ECounterAtMax);
```

- ❌ **Uncovered:** `assert!(counter.value < counter.max_value, ECounterAtMax)`

### Line 34

```move
public fun decrement(counter: &mut Counter) {
```

- ❌ **Uncovered:** `decrement`

### Line 35

```move
assert!(counter.value > 0, ECounterAtZero);
```

- ❌ **Uncovered:** `assert!(counter.value > 0, ECounterAtZero)`

### Line 36

```move
counter.value = counter.value - 1;
```

- ❌ **Uncovered:** `counter.value = counter.value - 1`
- ❌ **Uncovered:** `;`

### Line 40

```move
public fun reset(counter: &mut Counter) {
```

- ❌ **Uncovered:** `reset`

### Line 41

```move
counter.value = 0;
```

- ❌ **Uncovered:** `counter.value = 0`
- ❌ **Uncovered:** `;`

### Line 50

```move
public fun is_at_max(counter: &Counter): bool {
```

- ❌ **Uncovered:** `is_at_max`

### Line 51

```move
counter.value == counter.max_value
```

- ❌ **Uncovered:** `counter.value == counter.max_value`

### Line 60

```move
public fun increment_by(counter: &mut Counter, amount: u64) {
```

- ❌ **Uncovered:** `increment_by`

### Line 61

```move
let new_value = counter.value + amount;
```

- ❌ **Uncovered:** `new_value`
- ❌ **Uncovered:** `counter.value`
- ❌ **Uncovered:** `+`
- ❌ **Uncovered:** `amount`

### Line 62

```move
if (new_value > counter.max_value) {
```

- ❌ **Uncovered:** `if (new_value > counter.max_value) {`

### Line 63

```move
counter.value = counter.max_value;
```

- ❌ **Uncovered:** `            counter.value = counter.max_value;`

### Line 64

```move
} else {
```

- ❌ **Uncovered:** `        } else {`

### Line 65

```move
counter.value = new_value;
```

- ❌ **Uncovered:** `            counter.value = new_value;`

### Line 66

```move
}
```

- ❌ **Uncovered:** `        }`

## Suggestions

### Test Assertion Failure Paths

- [ ] Line 19: `assert!(max_value > 0, EInvalidMaxValue)`
  - Write a test where this assertion **fails**
- [ ] Line 29: `assert!(counter.value < counter.max_value, ECounterAtMax)`
  - Write a test where this assertion **fails**
- [ ] Line 35: `assert!(counter.value > 0, ECounterAtZero)`
  - Write a test where this assertion **fails**

### Call Uncovered Functions

- [ ] `decrement()`
- [ ] `reset()`
- [ ] `is_at_max()`
- [ ] `increment_by()`
- [ ] `new_value()`
- [ ] `amount()`
