/// A bounded counter — the example "real behavior" this template ships.
///
/// The model is a plain value type with no UI imports, so every rule it
/// enforces (clamping, validated construction) is directly testable with
/// `swift test`. Replace it with your app's real domain logic and keep the
/// same shape: logic in `TemplateAppKit`, UI in `TemplateApp`.
public struct CounterModel: Equatable, Sendable {
    /// Inclusive bounds the count may never leave.
    public let range: ClosedRange<Int>

    /// Current count; mutate only through ``increment()`` / ``decrement()``.
    public private(set) var count: Int

    /// A counter from 0 through 10 starting at 0.
    public init() {
        self.range = 0...10
        self.count = 0
    }

    /// A counter with custom bounds. Fails if `initialCount` is outside `range`.
    public init?(range: ClosedRange<Int>, initialCount: Int) {
        guard range.contains(initialCount) else { return nil }
        self.range = range
        self.count = initialCount
    }

    /// True when the count sits at `range.upperBound`.
    public var isAtUpperBound: Bool { count == range.upperBound }

    /// True when the count sits at `range.lowerBound`.
    public var isAtLowerBound: Bool { count == range.lowerBound }

    /// Adds one, clamped to `range.upperBound`.
    public mutating func increment() {
        count = min(count + 1, range.upperBound)
    }

    /// Subtracts one, clamped to `range.lowerBound`.
    public mutating func decrement() {
        count = max(count - 1, range.lowerBound)
    }
}
