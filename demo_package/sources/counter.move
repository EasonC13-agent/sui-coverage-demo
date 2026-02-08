/// A simple counter module with intentional coverage gaps for demo purposes
module demo_package::counter {

    /// The Counter object
    public struct Counter has key, store {
        id: UID,
        value: u64,
        max_value: u64,
    }

    /// Error codes
    const ECounterAtMax: u64 = 0;
    const ECounterAtZero: u64 = 1;
    const EInvalidMaxValue: u64 = 2;

    /// Create a new counter with a max value
    public fun new(max_value: u64, ctx: &mut TxContext): Counter {
        assert!(max_value > 0, EInvalidMaxValue);
        Counter {
            id: object::new(ctx),
            value: 0,
            max_value,
        }
    }

    /// Increment the counter
    public fun increment(counter: &mut Counter) {
        assert!(counter.value < counter.max_value, ECounterAtMax);
        counter.value = counter.value + 1;
    }

    /// Decrement the counter
    public fun decrement(counter: &mut Counter) {
        assert!(counter.value > 0, ECounterAtZero);
        counter.value = counter.value - 1;
    }

    /// Reset the counter to zero
    public fun reset(counter: &mut Counter) {
        counter.value = 0;
    }

    /// Get current value
    public fun value(counter: &Counter): u64 {
        counter.value
    }

    /// Check if counter is at max
    public fun is_at_max(counter: &Counter): bool {
        counter.value == counter.max_value
    }

    /// Check if counter is at zero
    public fun is_at_zero(counter: &Counter): bool {
        counter.value == 0
    }

    /// Increment by amount (with bounds check)
    public fun increment_by(counter: &mut Counter, amount: u64) {
        let new_value = counter.value + amount;
        if (new_value > counter.max_value) {
            counter.value = counter.max_value;
        } else {
            counter.value = new_value;
        }
    }

    /// Delete the counter
    public fun destroy(counter: Counter) {
        let Counter { id, value: _, max_value: _ } = counter;
        object::delete(id);
    }

    // ========== Tests ==========

    #[test]
    fun test_new_counter() {
        let mut ctx = tx_context::dummy();
        let counter = new(100, &mut ctx);
        assert!(value(&counter) == 0, 0);
        destroy(counter);
    }

    #[test]
    fun test_increment() {
        let mut ctx = tx_context::dummy();
        let mut counter = new(100, &mut ctx);
        increment(&mut counter);
        assert!(value(&counter) == 1, 0);
        increment(&mut counter);
        assert!(value(&counter) == 2, 0);
        destroy(counter);
    }

    #[test]
    fun test_is_at_zero() {
        let mut ctx = tx_context::dummy();
        let mut counter = new(100, &mut ctx);
        assert!(is_at_zero(&counter), 0);
        increment(&mut counter);
        assert!(!is_at_zero(&counter), 1);
        destroy(counter);
    }

    // NOTE: The following functions are NOT tested:
    // - decrement() - never called
    // - reset() - never called  
    // - is_at_max() - never called
    // - increment_by() - partially tested (only one branch)
    // - ECounterAtMax error path - never triggered
    // - ECounterAtZero error path - never triggered
    // - EInvalidMaxValue error path - never triggered
}
