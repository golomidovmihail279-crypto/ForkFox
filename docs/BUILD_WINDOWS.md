# Windows 11 Chromium build checklist

Status: phase-zero preparation; no Chromium build has been run.

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
- A fast SSD and additional free-space headroom are strongly preferred. Keep the source path short and avoid spaces in it.
- The initial source checkout can take more than an hour on a fast connection and much longer on slower connections.
- Run the first-time \`gclient\` setup from \`cmd.exe\`, not PowerShell. Chromium warns that the bundled Git/Python tools may not install correctly when this step is run from a non-cmd shell.
- Set \`DEPOT_TOOLS_WIN_TOOLCHAIN=0\` so depot_tools uses the locally installed Visual Studio. The official guide notes that \`vs2026_install\` may also be needed when Visual Studio is installed in a non-default location.
- The official build uses GN to generate the build directory, Siso/Ninja through \`autoninja\` to compile, and the \`chrome\` target to avoid building every test binary.

## ForkFox phase-zero sequence

1. Run the read-only environment preflight and review its output.
2. Confirm that at least one NTFS drive has 100 GB or more free; additional headroom is recommended.
3. Install only missing official prerequisites.
4. Clone depot_tools and complete its first-time setup from \`cmd.exe\`.
5. Fetch an upstream Chromium checkout into a short path such as \`C:\src\chromium\`.
6. Generate a build directory, build and run unmodified upstream Chromium.
7. Record source revision, checkout/build size, build time, startup time, idle RAM/CPU, and process count.
8. Only after the upstream baseline works, begin ForkFox-specific browser changes.

## Command sequence (after prerequisites are verified)

Run the first-time depot_tools setup in Command Prompt (\`cmd.exe\`):

\`\`\`bat
mkdir C:\src
cd /d C:\src
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
set DEPOT_TOOLS_WIN_TOOLCHAIN=0
set PATH=C:\src\depot_tools;%PATH%
gclient
\`\`\`

Then fetch and build Chromium:

\`\`\`bat
cd /d C:\src
mkdir chromium
cd chromium
fetch chromium
cd src
gn gen out\Default
autoninja -C out\Default chrome
out\Default\chrome.exe
\`\`\`

These commands are documented for the official upstream Chromium tree. They have not been run for ForkFox. Do not start the checkout until the machine's actual disk space and toolchain have been checked.

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
