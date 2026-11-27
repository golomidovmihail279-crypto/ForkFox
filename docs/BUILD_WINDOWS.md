# Windows 11 Chromium build checklist

Status: phase-zero preparation; no build has been run.

Source of truth:
- https://chromium.googlesource.com/chromium/src/+/main/docs/windows_build_instructions.md

## Official prerequisites checked on 2026-11-27

- x86-64 Windows machine.
- At least 8 GB RAM; more than 16 GB is highly recommended. The upstream guide notes that 64 GB is not excessive for faster builds.
- At least 100 GB free on an NTFS-formatted drive. This is an upstream minimum, not a guarantee that every checkout/build configuration will fit comfortably.
- Visual Studio 2026 (18.0.0 or newer), with Desktop development with C++ and MFC/ATL support.
- Windows 11 SDK 10.0.28000.2270.
- Windows SDK Debugging Tools 10.0.26100.3323 or newer.
- Git for Windows and Chromium's depot_tools.

## Important implications

- A full Chromium checkout and build is a large development workload, not a small app project.
- A fast SSD and plenty of free space are important. Keep the source path short and avoid spaces in it.
- The initial source checkout can take more than an hour on a fast connection and much longer on slower connections.
- Chromium's build guide recommends using cmd.exe for the initial depot_tools setup so its bundled tools install correctly.
- The official build command for the browser target is: `autoninja -C out\\Default chrome`.
- The resulting development browser is: `out\\Default\\chrome.exe`.
- Do not start a build until the actual free disk space, RAM, Visual Studio version, SDKs, and Git setup have been checked.

## ForkFox phase-zero sequence

1. Check the development PC's exact free space on an NTFS SSD.
2. Check installed RAM and Visual Studio version/components.
3. Install only missing official prerequisites.
4. Fetch an upstream Chromium checkout into a short path such as `C:\\src\\chromium`.
5. Build and run unmodified upstream Chromium first.
6. Record source revision, checkout size, build size/time, startup time, idle RAM/CPU, and process count.
7. Only after the baseline works, begin ForkFox-specific changes.

## Resource benchmark baseline

Use the same machine and test steps for upstream Chromium and ForkFox:

- Cold launch.
- Two-minute idle on a blank page.
- One lightweight page after settling.
- Five tabs on different sites.
- Video playback.
- Minimized for five minutes.
- Browser open while a game runs.
- Close tabs and measure memory reclamation.

Record total browser process-tree working set/private bytes and CPU, not just the main process.

## Constraints

- This document is a preparation checklist, not a claim that Chromium has been downloaded or built.
- No GitHub Actions are to be run during this phase.
- Do not disable antivirus globally or weaken Windows security to speed up builds.
- Do not remove Chromium sandboxing or security features to reduce runtime memory.