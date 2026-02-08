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

    // ========== Additional Tests for Full Coverage ==========

    #[test]
    fun test_decrement() {
        let mut ctx = tx_context::dummy();
        let mut counter = new(100, &mut ctx);
        increment(&mut counter);
        increment(&mut counter);
        assert!(value(&counter) == 2, 0);
        decrement(&mut counter);
        assert!(value(&counter) == 1, 0);
        destroy(counter);
    }

    #[test]
    fun test_reset() {
        let mut ctx = tx_context::dummy();
        let mut counter = new(100, &mut ctx);
        increment(&mut counter);
        increment(&mut counter);
        assert!(value(&counter) == 2, 0);
        reset(&mut counter);
        assert!(value(&counter) == 0, 0);
        destroy(counter);
    }

    #[test]
    fun test_is_at_max() {
        let mut ctx = tx_context::dummy();
        let mut counter = new(2, &mut ctx);
        assert!(!is_at_max(&counter), 0);
        increment(&mut counter);
        assert!(!is_at_max(&counter), 1);
        increment(&mut counter);
        assert!(is_at_max(&counter), 2);
        destroy(counter);
    }

    #[test]
    fun test_increment_by_normal() {
        let mut ctx = tx_context::dummy();
        let mut counter = new(100, &mut ctx);
        increment_by(&mut counter, 5);
        assert!(value(&counter) == 5, 0);
        increment_by(&mut counter, 10);
        assert!(value(&counter) == 15, 0);
        destroy(counter);
    }

    #[test]
    fun test_increment_by_overflow() {
        let mut ctx = tx_context::dummy();
        let mut counter = new(10, &mut ctx);
        increment_by(&mut counter, 5);
        assert!(value(&counter) == 5, 0);
        // This should cap at max_value (10), not go to 20
        increment_by(&mut counter, 15);
        assert!(value(&counter) == 10, 1);
        assert!(is_at_max(&counter), 2);
        destroy(counter);
    }

    #[test]
    #[expected_failure(abort_code = EInvalidMaxValue)]
    fun test_new_invalid_max_value() {
        let mut ctx = tx_context::dummy();
        let counter = new(0, &mut ctx);  // Should fail: max_value must be > 0
        destroy(counter);
    }

    #[test]
    #[expected_failure(abort_code = ECounterAtMax)]
    fun test_increment_at_max() {
        let mut ctx = tx_context::dummy();
        let mut counter = new(2, &mut ctx);
        increment(&mut counter);
        increment(&mut counter);
        // Counter is now at max (2), this should fail
        increment(&mut counter);
        destroy(counter);
    }

    #[test]
    #[expected_failure(abort_code = ECounterAtZero)]
    fun test_decrement_at_zero() {
        let mut ctx = tx_context::dummy();
        let mut counter = new(100, &mut ctx);
        // Counter is at 0, decrement should fail
        decrement(&mut counter);
        destroy(counter);
    }
}
