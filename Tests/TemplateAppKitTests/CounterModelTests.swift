import Testing

@testable import TemplateAppKit

@Suite("CounterModel")
struct CounterModelTests {
    @Test("starts at zero with the default 0...10 range")
    func defaultInitialState() {
        let model = CounterModel()
        #expect(model.count == 0)
        #expect(model.range == 0...10)
        #expect(model.isAtLowerBound)
        #expect(!model.isAtUpperBound)
    }

    @Test("increment adds one and clamps at the upper bound")
    func incrementClampsAtUpperBound() throws {
        var model = try #require(CounterModel(range: 0...2, initialCount: 1))
        model.increment()
        #expect(model.count == 2)
        #expect(model.isAtUpperBound)
        model.increment()  // already at the bound — must not exceed it
        #expect(model.count == 2)
    }

    @Test("decrement subtracts one and clamps at the lower bound")
    func decrementClampsAtLowerBound() throws {
        var model = try #require(CounterModel(range: -1...5, initialCount: 0))
        model.decrement()
        #expect(model.count == -1)
        #expect(model.isAtLowerBound)
        model.decrement()  // already at the bound — must not go below it
        #expect(model.count == -1)
    }

    @Test(
        "custom init rejects an initial count outside the range",
        arguments: [(0...10, 11), (0...10, -1), (5...5, 4)]
    )
    func customInitRejectsOutOfRangeStart(range: ClosedRange<Int>, start: Int) {
        #expect(CounterModel(range: range, initialCount: start) == nil)
    }

    @Test("custom init accepts boundary values exactly")
    func customInitAcceptsBoundaryValues() throws {
        let atLower = try #require(CounterModel(range: 3...7, initialCount: 3))
        #expect(atLower.count == 3)
        let atUpper = try #require(CounterModel(range: 3...7, initialCount: 7))
        #expect(atUpper.count == 7)
    }
}
