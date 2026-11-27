# ForkFox

An independent browser project for Windows 11 x64, designed with gaming workloads in mind.

## Project status

**Early architecture stage.** ForkFox starts from a clean slate. No code or architecture from the previous ForkFox project is being reused.

## Independence

ForkFox will be its own browser product: its own name, interface, settings, defaults, profile experience, and gaming-oriented features, built on the open-source Chromium browser platform.

The engine direction is a **direct Chromium source fork**, using Chromium's browser/content platform rather than Microsoft Edge, WebView2, Electron, or a prebuilt browser shell. Chromium is an open-source project and is not owned by Microsoft. Windows 11 system APIs will still be used for normal desktop integration.

## Product priorities

1. Minimize idle RAM and CPU use without breaking modern websites.
2. Maintain a secure, regularly updated browser engine.
3. Keep the browser UI and background services minimal.
4. Keep gaming optimizations optional; low-overhead behavior is always active.
5. Store profile data locally and encrypt passwords and backups.

## Engine direction

Use the Chromium source tree as the maintained engine and browser-platform foundation, then develop the ForkFox browser experience as a separate branded product. Reuse engine and security infrastructure; do not copy Chrome's product design or add Google-only services by default.

A direct Chromium fork provides more control over browser processes, profiles, downloads, permissions, and UI integration than a thin embedded-browser wrapper. It also creates a substantial build and upstream-maintenance burden. Memory use is not assumed to be lower than Chrome or Edge; it must be measured.

See [docs/ENGINE_DECISION.md](docs/ENGINE_DECISION.md) and [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

## Build policy

GitHub Actions are intentionally not enabled during development. They will only be considered for a final Windows installer/EXE build after explicit approval.
