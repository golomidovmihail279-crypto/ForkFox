# ForkFox

A new, lightweight desktop browser for Windows 11 x64, designed with gaming workloads in mind.

## Project status

**Early architecture / foundation stage.** This repository starts from a clean slate. No code or design is being carried over from the previous ForkFox project.

## Product priorities

1. Keep idle RAM and CPU use as low as practical.
2. Preserve compatibility with modern websites.
3. Keep browser UI and background services minimal.
4. Provide optional gaming optimizations without making normal browsing depend on them.
5. Store profile data locally and protect passwords and backups with encryption.

## Platform

- Windows 11 x64 only.

## Initial engine decision

The current implementation candidate is **Microsoft Edge WebView2 Evergreen Runtime**, hosted by a small native Windows application. This is a practical embedding choice, not a claim that Chromium has the lowest possible memory use. Its shared, automatically updated runtime avoids bundling a second full browser engine with ForkFox. Actual idle and workload measurements will determine whether this choice meets the project's resource goals.

See [docs/ENGINE_DECISION.md](docs/ENGINE_DECISION.md) and [docs/PRODUCT_SPEC.md](docs/PRODUCT_SPEC.md).

## Build policy

GitHub Actions are intentionally not enabled during early development. They will only be considered for a final Windows installer/EXE build after explicit approval.
