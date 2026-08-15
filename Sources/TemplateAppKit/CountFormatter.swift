/// Formats a click count for display — the second piece of tested behavior.
public enum CountFormatter {
    /// Human-readable label for a click count.
    ///
    /// - `...0` → `"No clicks yet"` (negative input is treated as zero,
    ///   never rendered)
    /// - `1` → `"1 click"`
    /// - `n` → `"\(n) clicks"`
    public static func label(forClicks count: Int) -> String {
        switch count {
        case ...0:
            return "No clicks yet"
        case 1:
            return "1 click"
        default:
            return "\(count) clicks"
        }
    }
}
