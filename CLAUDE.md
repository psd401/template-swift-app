# CLAUDE.md — template-swift-app

Map, not manual. Change this file in the same PR that changes the convention.

## Stack

- Swift 6 (`swift-tools-version: 6.0`, macOS 14+) · Swift Package Manager only — no `.xcodeproj` committed
- SwiftUI app shell (`TemplateApp` executable target) over a logic library (`TemplateAppKit`)
- **Swift Testing** (`#expect` / `#require`, `@Suite`, parameterized `@Test`) for unit tests
- UI testing, when added, is **XCTest/XCUITest** — Swift Testing does not cover UI automation (per PSD testing standard)
- SwiftLint (config: `.swiftlint.yml`, CI runs `--strict`) · swift-format (config: `.swift-format`, 4-space indent)

## Commands (exact)

```bash
swift build                                        # build (CI gate)
swift test                                         # Swift Testing suite (CI gate)
swiftlint lint --strict                            # lint, warnings = errors (CI gate)
swiftlint --fix                                    # SwiftLint autocorrect
swift format --in-place --recursive Sources Tests  # autoformat
swift format lint --strict --recursive Sources Tests  # format check (not a CI gate)
swift run TemplateApp                              # launch the app window locally
```

## Map

- `Package.swift` — 3 targets: `TemplateAppKit` (library, all logic), `TemplateApp` (executable, SwiftUI shell), `TemplateAppKitTests`.
- `Sources/TemplateAppKit/` — `CounterModel` (bounded counter, failable validated init) + `CountFormatter` (display labels). The example behavior; replace with your domain.
- `Sources/TemplateApp/TemplateApp.swift` — `@main` App + `ContentView`; binds to library types only.
- `Tests/TemplateAppKitTests/` — one test file per source file; exact-value assertions; parameterized tests for input families.
- `.github/workflows/psd-ci.yml` — **self-contained** (macos-15). Swift repos do NOT call the org reusable CI (it runs ubuntu). Check context is `psd-ci`, not `psd-ci / psd-ci` — rulesets must list both.
- `.github/workflows/release-macos.yml.disabled` — commented-out signing/notarization scaffolding (psd-sign → Jamf); rename + uncomment when shipping.

## Conventions

- Logic goes in `TemplateAppKit`; the executable target stays a thin SwiftUI binding layer. If a behavior is worth testing, it does not live in `Sources/TemplateApp/`.
- New tests use Swift Testing: `#expect` for assertions, `try #require` to unwrap optionals, `arguments:` for input families. XCTest only for UI automation targets.
- Value types + `Sendable` by default; validated construction via failable inits rather than post-hoc checks.
- Test-first for non-trivial logic; watch the test fail before making it pass. Existing tests are contracts: weakening or deleting an assertion must be declared in the PR body.
- Dependencies: add to `Package.swift`, commit `Package.resolved` in the same PR, state why in the PR body. This template ships with zero dependencies — keep it that way unless the app needs one.
- Actions in workflows are SHA-pinned with a version comment.

## Anti-patterns (will fail review)

- Logic in the executable target "because it's faster" — it is untestable there by design.
- New unit tests written in XCTest (`XCTAssert*`) — Swift Testing is the standard for new unit tests.
- Assertion-free tests; deleting or skipping a failing test to get green.
- Committing an `.xcodeproj`, `xcuserdata/`, or `.build/`.
- Switching CI to the org reusable workflow — it runs ubuntu and cannot build Swift/macOS.
- Activating release-macos.yml.disabled without a working `scripts/build-macos-pkg.sh` and the MACOS_* secrets confirmed.

## PR evidence bar

`swift build` + `swift test` + `swiftlint lint --strict` output pasted in the PR; bug fixes include a failing-then-passing test.
