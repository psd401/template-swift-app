import AppKit
import SwiftUI
import TemplateAppKit

/// SwiftUI shell over `TemplateAppKit`. Keep this target thin: views bind to
/// library types; behavior worth testing belongs in the library.
@main
struct TemplateApp: App {
    init() {
        // SPM executables have no app bundle, so activate explicitly to get
        // a foreground window from `swift run`. The psd-sign pipeline wraps
        // the binary in a proper .app for Jamf distribution at release time.
        NSApplication.shared.setActivationPolicy(.regular)
        NSApplication.shared.activate(ignoringOtherApps: true)
    }

    var body: some Scene {
        WindowGroup("Template App") {
            ContentView()
        }
        .windowResizability(.contentSize)
    }
}

struct ContentView: View {
    @State private var model = CounterModel()

    var body: some View {
        VStack(spacing: 12) {
            Text(CountFormatter.label(forClicks: model.count))
                .font(.title2)
                .monospacedDigit()
            HStack(spacing: 8) {
                Button("−") { model.decrement() }
                    .disabled(model.isAtLowerBound)
                Button("+") { model.increment() }
                    .disabled(model.isAtUpperBound)
            }
            Text("Bounded \(model.range.lowerBound)–\(model.range.upperBound)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(24)
        .frame(minWidth: 240)
    }
}
