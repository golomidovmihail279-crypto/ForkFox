# Engine decision record

Status: **revised direction — Firefox/Gecko source fork; prototype and footprint validation required**

Date: 2026-11-27

## User requirement

ForkFox must not be based on Microsoft browser technology. Microsoft Edge, WebView2, and CEF are excluded.

The target operating system remains Windows 11 x64. A Windows desktop program necessarily uses operating-system interfaces for windows, input, files, networking, and graphics. The independence requirement applies to the browser engine/runtime and browser platform, not to the host operating system.

## Selected direction: Firefox source-code fork (Gecko)

Use Mozilla's maintained Firefox source tree as the browser-engine and application-platform foundation, then create a ForkFox-branded browser experience and remove or disable features that are not needed, where this can be done safely.

This is not the same as embedding Gecko using old XULRunner or legacy Gecko SDK components. Those older embedding paths are not a sound foundation for a new modern browser. Mozilla's supported GeckoView product is focused on Android; for Windows desktop the practical maintained route is to work from the full Firefox source codebase.

Official sources:
- Firefox source and contributor documentation: https://firefox-source-docs.mozilla.org/
- Windows build guide: https://firefox-source-docs.mozilla.org/setup/windows_build.html
- Supported build hosts and targets: https://firefox-source-docs.mozilla.org/contributing/build/supported.html
- Mozilla Firefox source repository: https://github.com/mozilla-firefox/firefox
- GeckoView project: https://mozilla.github.io/geckoview/

## Why this direction

- Avoids Microsoft Edge / WebView2 as the rendering engine.
- Uses Gecko, not Chromium/Blink.
- Starts from an actively maintained browser codebase with an established security-update process.
- Provides a realistic route to modern website compatibility, profiles, downloads, media, and browser security.
- Allows ForkFox-specific UI and gaming-oriented behavior to be developed without inventing a web engine.

## Important costs and risks

- Firefox is a large, complex codebase. A custom build and branding effort is substantially harder than writing a small native wrapper.
- Building Firefox on Windows requires Mozilla's build environment and supported compiler/toolchain. The build is resource- and disk-intensive.
- Stripping Firefox features can break site compatibility, security, accessibility, or updates. Remove only measured, understood components.
- Forking creates an ongoing obligation to merge upstream security and compatibility updates.
- A Gecko-based browser is not guaranteed to use less RAM than WebView2 or Edge. This must be measured; no memory promise is made yet.
- Mozilla's old Gecko embedding and XULRunner documentation is archived/legacy and must not be used as the main integration plan.

## Alternatives explicitly rejected

### Microsoft Edge WebView2

Rejected because it depends on the Microsoft Edge WebView2 Runtime.

### Chromium Embedded Framework (CEF)

Rejected because it is Chromium-based and does not meet the requirement to avoid that browser platform/runtime.

### Legacy Gecko embedding / XULRunner

Rejected as the main plan because the available embedding material is old and not a current supported desktop embedding product.

### Building a browser engine from zero

Not viable for this project's scope. A modern secure engine requires years of engineering, standards work, sandboxing, JavaScript runtime, graphics, media, networking, accessibility, and continuous security maintenance.

## Required measurements

Before claiming ForkFox is lightweight, benchmark the custom build against current Firefox on the same Windows 11 x64 machine:

1. Cold launch to usable window.
2. Idle for 2 minutes on a blank/new-tab page.
3. One lightweight website after settling.
4. Five tabs across different origins.
5. YouTube idle and video playback.
6. Browser minimized for 5 minutes.
7. Game running while ForkFox is open.
8. Close tabs and measure memory reclamation.

Record total process-tree working set/private bytes, process count, CPU average and peak, launch time, build revision, and test-machine details.

## Exit criteria

Continue with Gecko only if we can maintain upstream security updates and the measured resource use is acceptable. If we cannot maintain secure upstream updates, a custom browser fork is not safe to ship.
