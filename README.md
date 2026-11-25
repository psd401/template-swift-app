# template-swift-app

PSD401 template for macOS apps. Swift Package Manager + SwiftUI + Swift Testing, macOS 14+, zero dependencies.

## What this template gives you

- **Testable-by-construction layout**: `TemplateAppKit` library target holds all logic; the `TemplateApp` executable target is a thin SwiftUI shell. The example behavior is a bounded `CounterModel` (clamping, failable validated init) plus a `CountFormatter` (empty/singular/plural display labels).
- **Swift Testing suite**: 8 tests / 12 cases using `#expect`, `try #require`, `@Suite`, and parameterized `@Test(arguments:)` — exact-value assertions, boundary and rejection paths. UI testing, when you add it, stays XCTest/XCUITest per the PSD testing standard.
- **Lint + format**: SwiftLint (`.swiftlint.yml`, sensible opt-ins, `--strict` in CI) and swift-format (`.swift-format`, 4-space indent, 120 cols). Autocorrect: `swiftlint --fix` and `swift format --in-place --recursive Sources Tests`.
- **Self-contained macOS CI** (`.github/workflows/psd-ci.yml`, `macos-15`, SHA-pinned actions): build + test + strict lint (SwiftLint installed via brew — it is not on the runner's PATH despite the image README). Runs on pull requests only; a PR whose every changed file is Markdown skips the gates without starting a macOS runner, and a new push cancels the superseded run.
- **Release scaffolding**: `release-macos.yml.disabled` ships fully commented out — Developer ID signing, notarization, and .pkg publishing modeled on atrium-capture, referencing the org `MACOS_*` secrets. Rename + uncomment when the app ships to Jamf Self Service via the psd-sign pipeline (a comments-only `.yml` in `workflows/` registers a failing run on every push, hence the suffix).
- **PSD standard kit**: claude-review, security-scan and OpenWiki org reusable callers, Dependabot (github-actions + swift, weekly, minor/patch grouped), MIT LICENSE, map-style AGENTS.md (`CLAUDE.md` imports it).

## Swift CI is different — read this

The org reusable CI (`PSD401/.github/reusable-psd-ci.yml`) runs on **ubuntu** and cannot build Swift/macOS, so this template's gates run in job `swift` of `psd-ci.yml`, on `macos-15`. Job `psd-ci` then calls the org reusable with `if: always()`, `upstream-results: ${{ join(needs.*.result, ' ') }}` and `gate: "off"` (psd-dev-standards standards/06 §2, repo-specific gate jobs): the reusable fails unless `swift` succeeded, and runs the org runtime-standard step.

Consequence for branch protection: the caller job `psd-ci` calls a reusable whose job is also `psd-ci`, so the check context is **`psd-ci / psd-ci`** — the same context every other PSD401 repo reports and the only one the org rulesets require (psd-dev-standards decision of 2026-10-10). A plain job with steps would report plain `psd-ci`, which the rulesets don't accept, so don't rename job `psd-ci` or give it steps. The reusable counts a skipped upstream job as a failure, so the docs-only skip lives in `swift`'s steps (a Linux runner and one echo step), never in a job-level `if:`.

## First 10 minutes

1. **Rename**: `name` in `Package.swift`, the three target names and their directories under `Sources/` and `Tests/`, the `@main` struct in `Sources/TemplateApp/TemplateApp.swift`, and the artifact names in `release-macos.yml.disabled`. Naming: lowercase-kebab repo, `psd-` prefix for district-specific apps.
2. **Set repo custom properties**: `tier` (default `c-experiment`), `owner`, `lifecycle: active`; add topics (`swift`, `macos`, …).
3. **Verify green**: `swift build && swift test && swiftlint lint --strict` (install SwiftLint locally with `brew install swiftlint` if needed).
4. **Run it**: `swift run TemplateApp` — a window with the bounded counter appears.
5. **Review AGENTS.md** and prune it to your app.
6. Replace `CounterModel`/`CountFormatter` and their tests with your real domain logic — never leave the repo with zero tests.
7. **When ready to ship**: follow the header in `.github/workflows/release-macos.yml.disabled` (rename, uncomment, build-pkg script, `MACOS_*` secrets), then hand the notarized .pkg to Technology Services for Jamf Self Service.

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
