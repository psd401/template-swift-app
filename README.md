# template-swift-app

PSD401 template for macOS apps. Swift Package Manager + SwiftUI + Swift Testing, macOS 14+, zero dependencies.

## What this template gives you

- **Testable-by-construction layout**: `TemplateAppKit` library target holds all logic; the `TemplateApp` executable target is a thin SwiftUI shell. The example behavior is a bounded `CounterModel` (clamping, failable validated init) plus a `CountFormatter` (empty/singular/plural display labels).
- **Swift Testing suite**: 8 tests / 12 cases using `#expect`, `try #require`, `@Suite`, and parameterized `@Test(arguments:)` — exact-value assertions, boundary and rejection paths. UI testing, when you add it, stays XCTest/XCUITest per the PSD testing standard.
- **Lint + format**: SwiftLint (`.swiftlint.yml`, sensible opt-ins, `--strict` in CI) and swift-format (`.swift-format`, 4-space indent, 120 cols). Autocorrect: `swiftlint --fix` and `swift format --in-place --recursive Sources Tests`.
- **Self-contained macOS CI** (`.github/workflows/psd-ci.yml`, `macos-15`, SHA-pinned actions): build + test + strict lint. SwiftLint is preinstalled on the runner image.
- **Release scaffolding**: `release-macos.yml` ships fully commented out — Developer ID signing, notarization, and .pkg publishing modeled on atrium-capture, referencing the org `MACOS_*` secrets. Activate it when the app ships to Jamf Self Service via the psd-sign pipeline.
- **PSD standard kit**: claude-review + license-check org reusable callers, Dependabot (github-actions + swift, weekly, minor/patch grouped), MIT LICENSE, map-style CLAUDE.md.

## Swift CI is different — read this

The org reusable CI (`PSD401/.github/reusable-psd-ci.yml`) runs on **ubuntu** and cannot build Swift/macOS, so this template's `psd-ci.yml` is a **self-contained workflow on `macos-15`** instead of a thin caller.

Consequence for branch protection: a direct job produces the check context **`psd-ci`**, while repos calling the reusable produce **`psd-ci / psd-ci`**. Org rulesets that require CI must list **both** contexts, or Swift repos will never satisfy the required check.

## First 10 minutes

1. **Rename**: `name` in `Package.swift`, the three target names and their directories under `Sources/` and `Tests/`, the `@main` struct in `Sources/TemplateApp/TemplateApp.swift`, and the artifact names in the commented `release-macos.yml`. Naming: lowercase-kebab repo, `psd-` prefix for district-specific apps.
2. **Set repo custom properties**: `tier` (default `c-experiment`), `owner`, `lifecycle: active`; add topics (`swift`, `macos`, …).
3. **Verify green**: `swift build && swift test && swiftlint lint --strict` (install SwiftLint locally with `brew install swiftlint` if needed).
4. **Run it**: `swift run TemplateApp` — a window with the bounded counter appears.
5. **Review CLAUDE.md** and prune it to your app.
6. Replace `CounterModel`/`CountFormatter` and their tests with your real domain logic — never leave the repo with zero tests.
7. **When ready to ship**: follow the header in `.github/workflows/release-macos.yml` (build-pkg script + `MACOS_*` secrets), then hand the notarized .pkg to Technology Services for Jamf Self Service.

## Commands

| Task | Command |
|------|---------|
| Build | `swift build` |
| Test | `swift test` |
| Lint (CI gate) | `swiftlint lint --strict` |
| Lint autocorrect | `swiftlint --fix` |
| Format | `swift format --in-place --recursive Sources Tests` |
| Format check | `swift format lint --strict --recursive Sources Tests` |
| Run the app | `swift run TemplateApp` |
| Release build | `swift build -c release` |

## Owner

Technology Services, Peninsula School District.
