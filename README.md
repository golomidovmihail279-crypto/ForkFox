# ForkFox

An independent browser project for Windows 11 x64, designed with gaming workloads in mind.

## Project status

**Early architecture stage.** ForkFox starts from a clean slate. No code or architecture from the previous ForkFox project is being reused.

## Independence

ForkFox will not use Microsoft Edge, WebView2, or CEF as its browser engine/runtime. The current engine direction is a Firefox/Gecko-based source fork with a custom ForkFox browser experience.

Because Windows 11 is the target operating system, the application will still use Windows system APIs for normal desktop integration. This does not make it an Edge-based browser.

## Product priorities

1. Minimize idle RAM and CPU use without breaking modern websites.
2. Maintain a secure, regularly updated browser engine.
3. Keep the browser UI and background services minimal.
4. Keep gaming optimizations optional; low-overhead behavior is always active.
5. Store profile data locally and encrypt passwords and backups.

## Engine direction

The project will investigate a **Firefox source-code fork (Gecko)** rather than embedding an obsolete standalone Gecko control. Mozilla's old embedding/XULRunner documentation is not a suitable foundation for a modern browser. Building from Firefox source is more demanding, but it follows a maintained browser codebase.

See [docs/ENGINE_DECISION.md](docs/ENGINE_DECISION.md) and [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

## Build policy

GitHub Actions are intentionally not enabled during development. They will only be considered for a final Windows installer/EXE build after explicit approval.
