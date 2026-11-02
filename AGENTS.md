# AGENTS.md — template-swift-app

Map, not manual. Change this file in the same PR that changes the convention.

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

## Conventions

- Logic goes in `TemplateAppKit`; the executable target stays a thin SwiftUI binding layer. If a behavior is worth testing, it does not live in `Sources/TemplateApp/`. `CounterModel` and `CountFormatter` are example behavior; replace them with your domain.
- CI gates live in `psd-ci-swift.yml`, a local reusable workflow, called by the job named `psd-ci` in `psd-ci.yml`. That job name is what makes the check context `psd-ci / psd-ci`, the only one the org rulesets accept; don't rename it or inline the gates.
- New tests use Swift Testing: `#expect` for assertions, `try #require` to unwrap optionals, `arguments:` for input families. XCTest only for UI automation targets — Swift Testing does not cover UI automation.
- Value types + `Sendable` by default; validated construction via failable inits rather than post-hoc checks.
- Test-first for non-trivial logic; watch the test fail before making it pass. Existing tests are contracts: weakening or deleting an assertion must be declared in the PR body.
- Dependencies: add to `Package.swift`, commit `Package.resolved` in the same PR, state why in the PR body. This template ships with zero dependencies — keep it that way unless the app needs one.
- Actions in workflows are SHA-pinned with a version comment.
- `release-macos.yml.disabled` is commented-out signing/notarization scaffolding (psd-sign → Jamf); rename and uncomment it when shipping.

## Anti-patterns (will fail review)

- Logic in the executable target "because it's faster" — it is untestable there by design.
- New unit tests written in XCTest (`XCTAssert*`) — Swift Testing is the standard for new unit tests.
- Assertion-free tests; deleting or skipping a failing test to get green.
- Committing an `.xcodeproj`, `xcuserdata/`, or `.build/` — this is a Swift Package Manager-only repo.
- Switching CI to the org reusable workflow — it runs ubuntu and cannot build Swift/macOS.
- Activating release-macos.yml.disabled without a working `scripts/build-macos-pkg.sh` and the MACOS_* secrets confirmed.

## PR evidence bar

`swift build` + `swift test` + `swiftlint lint --strict` output pasted in the PR; bug fixes include a failing-then-passing test.
