# Engine decision record

Status: **selected direction — direct Chromium source fork; feasibility and footprint validation required**

Date: 2026-11-27

## User requirement

ForkFox must be its own browser product, not a Firefox/Chrome re-skin. It must not depend on Microsoft Edge or WebView2. The target operating system is Windows 11 x64.

The product will have its own branding, browser UI, settings, start page, defaults, profile experience, and gaming-oriented features. It will reuse an established open-source browser engine rather than attempting to write a web engine from zero.

## Selected direction: direct Chromium source fork

Use the official Chromium source tree and its browser/content platform as the technical foundation. Build ForkFox as a separately branded browser application with its own product decisions and UI changes.

Official sources:
- Chromium source/build documentation: https://www.chromium.org/developers/how-tos/get-the-code/
- Official Windows build instructions: https://chromium.googlesource.com/chromium/src/+/main/docs/windows_build_instructions.md
- Chromium source repository: https://chromium.googlesource.com/chromium/src
- Chromium license information: https://www.chromium.org/chromium-projects/

## Why direct Chromium instead of a wrapper

- Gives ForkFox control over the browser application layer, not only an embedded web view.
- Provides access to Chromium's browser process model, tabs, navigation, profiles, downloads, permissions, media, PDF, sandboxing, and web platform.
- Avoids Microsoft Edge/WebView2 and avoids Electron as an application framework.
- Allows a custom ForkFox UI and product defaults while retaining Chromium's web compatibility and security work.
- Avoids depending on a third-party wrapper's release cadence and API limitations.

## Alternatives considered

### Microsoft Edge / WebView2

Rejected. The browser runtime depends on Microsoft Edge WebView2, which violates the independence requirement.

### Electron

Rejected. It adds an application framework and bundled Chromium runtime that are unnecessary for a performance-focused browser. ForkFox should use Chromium's browser platform directly.

### Chromium Embedded Framework (CEF)

Not selected for the first architecture. CEF is useful for embedding Chromium in another application, but ForkFox is a full browser product and needs deep control over browser-level behavior, profiles, permissions, downloads, and UI. A direct Chromium source fork is the more appropriate long-term foundation. CEF may be reconsidered only if a measured prototype shows that direct Chromium maintenance is impractical.

### Firefox / Gecko

Not selected. The user wants Chromium as the browser engine.

### Building a browser engine from zero

Not viable for this project's scope. A modern secure engine requires years of standards, JavaScript, graphics, networking, media, accessibility, sandboxing, and security engineering.

## Costs and risks

- Chromium is a very large codebase. A Windows build requires the Chromium toolchain, Visual Studio components, depot_tools, and substantial disk/build resources.
- The first successful build and every upstream roll can be time-consuming.
- A fork must continuously merge upstream security fixes. Falling behind on security updates makes public distribution unsafe.
- Removing features carelessly can break website compatibility, accessibility, permissions, or security.
- Chromium does not guarantee lower RAM use than Chrome or Edge. ForkFox must prove its resource goals through repeatable benchmarks.
- Branding and product independence do not mean rewriting Blink/V8/networking from scratch; those maintained components are the engine foundation.

## Required phase-zero validation

1. Read the current official Windows build requirements.
2. Confirm available disk space and toolchain prerequisites on the development machine.
3. Fetch and build an unmodified upstream Chromium revision.
4. Run it and record build time, disk use, idle RAM/CPU, process count, and startup time.
5. Establish how Chromium security releases will be tracked and merged.
6. Only then begin ForkFox-specific browser UI changes.

## Required measurements

Benchmark upstream Chromium and each ForkFox milestone on the same Windows 11 x64 machine:

1. Cold launch to usable window.
2. Idle for 2 minutes on a blank/new-tab page.
3. One lightweight website after settling.
4. Five tabs across different origins.
5. YouTube idle and video playback.
6. Browser minimized for 5 minutes.
7. Game running while ForkFox is open.
8. Close tabs and measure memory reclamation.

Record total process-tree working set/private bytes, process count, CPU average and peak, launch time, Chromium revision, and test-machine details.

## Exit criteria

Proceed only if the team can maintain timely Chromium security updates and the measured resource use is acceptable. Never remove sandboxing or essential security protections merely to reduce memory use.
