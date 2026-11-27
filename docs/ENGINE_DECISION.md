# Engine decision record

Status: **provisional selection — validate with a working prototype and measurements**

Date: 2026-11-27

## Decision

Use **Microsoft Edge WebView2 Evergreen Runtime** as the first implementation candidate, hosted inside a small native Windows 11 x64 application.

This is a pragmatic choice for a Windows-only browser. It is not a claim that WebView2 or Chromium is the lightest engine in every workload. The project must measure the actual baseline before treating the engine choice as final.

## Why WebView2 is the leading candidate

- Microsoft provides a supported native embedding control for Windows applications.
- Windows 11 includes the Evergreen WebView2 Runtime on supported installations.
- Evergreen apps share the installed runtime, and Microsoft documents memory, performance, and disk-footprint benefits from runtime sharing/hard-linking on eligible systems.
- The runtime updates on Microsoft's Edge release cadence, reducing the need for ForkFox to package and maintain its own Chromium runtime.
- The host can keep browser chrome (tabs, toolbar, settings) native and use WebView2 for website rendering.

Official sources:
- https://learn.microsoft.com/en-us/microsoft-edge/webview2/
- https://learn.microsoft.com/en-us/microsoft-edge/webview2/concepts/distribution
- https://learn.microsoft.com/en-us/microsoft-edge/webview2/concepts/evergreen-vs-fixed-version
- https://learn.microsoft.com/en-us/microsoft-edge/webview2/concepts/process-model

## Alternatives considered

### Gecko / GeckoView

Gecko is not selected for the Windows desktop prototype. Mozilla's maintained GeckoView embedding product is aimed at Android. Search results did not identify a current, supported general-purpose Gecko embedding API for Windows desktop apps. Building a full desktop browser around Gecko would likely mean maintaining a much larger Firefox-derived application rather than embedding a small control.

Sources:
- https://mozilla.github.io/geckoview/
- https://github.com/mozilla/geckoview
- https://github.com/mozilla/qbrt/issues/182

### Chromium Embedded Framework (CEF)

CEF is a real and mature embedding framework, but it brings Chromium binaries and resources with the application and uses Chromium's multi-process model. That increases distribution and update responsibility compared with using the shared Evergreen runtime already available on Windows 11. CEF remains a fallback if WebView2 lacks a required browser capability.

Sources:
- https://github.com/chromiumembedded/cef
- https://chromiumembedded.github.io/cef/architecture
- https://chromiumembedded.github.io/cef/general_usage

### Other engines

Servo and small commercial/experimental engines are not selected for the first version. A lightweight engine is not useful if it cannot reliably run modern sites, support required web APIs, receive security fixes, and be embedded and maintained on Windows.

## Important caveats

- WebView2 uses Chromium's multi-process architecture. A single browser window can involve browser, renderer, GPU, and utility processes.
- The host application can be small while the web engine still has a meaningful baseline memory footprint.
- A tab's website, scripts, media, and number of renderer processes can dominate memory use.
- CPU affinity or a displayed logical-core count is not the same as a reliable CPU usage limit. This feature needs a separate feasibility test; the UI must not promise exact per-core confinement if Windows/WebView2 cannot enforce it safely.
- Strong ad/tracker blocking, per-profile isolation, password storage, crash recovery, and safe updates all need prototype validation.

## Required benchmark before locking the engine

Record results on a clean Windows 11 x64 machine with the same runtime version and test conditions:

1. Cold launch to first usable window.
2. Idle for 2 minutes with one blank/new-tab page.
3. One lightweight site after settling.
4. Five tabs across different origins.
5. YouTube idle and video playback.
6. Browser minimized for 5 minutes.
7. Game running while ForkFox is open.
8. Close tabs and measure whether memory is reclaimed.

Record total ForkFox + WebView2 working set/private bytes, process count, CPU average and peak, launch time, and test-machine details. Compare against Edge using the same pages. No numeric RAM promise is made until these measurements exist.

## Exit criteria

Keep WebView2 only if it meets the project's compatibility, security, and measured resource targets. If it does not, investigate a different embedding strategy before adding product features.
