import Testing

@testable import TemplateAppKit

@Suite("CountFormatter")
struct CountFormatterTests {
    @Test("zero and negative counts read as the empty state")
    func zeroAndNegativeAreEmptyState() {
        #expect(CountFormatter.label(forClicks: 0) == "No clicks yet")
        #expect(CountFormatter.label(forClicks: -3) == "No clicks yet")
    }

    @Test("one click is singular")
    func singularForm() {
        #expect(CountFormatter.label(forClicks: 1) == "1 click")
    }

    @Test(
        "counts above one are plural with the exact number",
        arguments: [(2, "2 clicks"), (10, "10 clicks"), (144, "144 clicks")]
    )
    func pluralForm(count: Int, expected: String) {
        #expect(CountFormatter.label(forClicks: count) == expected)
    }
}
