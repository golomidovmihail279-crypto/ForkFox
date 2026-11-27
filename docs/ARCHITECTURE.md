# Initial architecture

Status: proposed architecture for a Firefox/Gecko-based ForkFox

## Platform

- Windows 11 x64.
- Firefox source tree and Gecko browser platform as the base.
- ForkFox branding, browser UI, settings, and gaming-oriented features developed as a maintained fork.
- No Microsoft Edge, WebView2, or CEF runtime.

Windows system APIs will still be used for ordinary desktop integration. This is unavoidable for a Windows application and is separate from the browser engine choice.

## High-level components

1. **Gecko browser platform** — rendering, JavaScript, networking, media, sandboxing, accessibility, and web standards.
2. **ForkFox browser chrome** — tabs, address bar, navigation, sidebar, menus, settings, and start page.
3. **Profile manager** — separate profile directories, cookies, site storage, settings, bookmarks, and credentials.
4. **Navigation/security layer** — URL handling, permissions, popup policy, certificate errors, and safe browsing integration.
5. **Privacy/filter layer** — request filtering, local filter lists, per-site allowlist, and update scheduling.
6. **Credential vault** — encrypted records, master-password flow, safe import/export.
7. **Session recovery** — crash-only recovery journal; normal close clears the recovery marker.
8. **Gaming controller** — optional game detection and background scheduling; no injection into games.
9. **Settings store** — versioned local configuration.
10. **Update mechanism** — notification-only updates; installation requires user approval. Engine updates must remain timely for security.

## Resource rules

- No unnecessary background polling or helper services.
- Prefer event-driven APIs.
- No telemetry by default.
- Do not remove security or sandboxing features to lower RAM.
- Defer noncritical work while a game is active.
- Measure the process tree and actual memory use; do not assume fewer processes always means lower or safer usage.
- Keep optional UI features disabled by default.
- Remove upstream browser components only after dependency and security review.

## Security rules

- Preserve Gecko's site isolation and sandboxing protections.
- Never expose privileged browser interfaces to arbitrary websites.
- Keep profile storage separated.
- Store secrets encrypted at rest; never log passwords, cookies, tokens, or raw imported CSV data.
- Treat imported files and filter lists as untrusted input.
- Verify update signatures and package integrity before offering installation.
- Track upstream Firefox security releases and establish a patch/merge cadence before public release.

## Implementation sequence

### Phase 0 — source and build feasibility
- Pin an upstream Firefox source revision.
- Read Mozilla's current Windows build requirements.
- Build an unmodified upstream browser locally to verify toolchain and environment.
- Record build time, disk use, idle RAM/CPU, and process tree.
- Document the upstream update and security-patching workflow.

### Phase 1 — ForkFox identity and browser shell
- Establish ForkFox branding and product defaults.
- Implement the initial tab/address-bar/navigation experience using supported Firefox platform architecture.
- Keep the initial UI minimal.
- Re-measure against the unmodified baseline.

### Phase 2 — browser basics
- Multi-tab and multi-window behavior.
- Search provider selection.
- Configurable start page, bookmarks, theme, and shortcuts.
- Download manager.

### Phase 3 — privacy and profiles
- Profile isolation.
- Ad/tracker blocking and popup policy.
- Clear-on-exit controls.
- Crash-only session recovery.
- Phishing protection after provider and licensing review.

### Phase 4 — credentials and backup
- Encrypted password vault.
- Chrome/Firefox import and encrypted export.
- Encrypted profile backup/restore.
- Security review before release.

### Phase 5 — optional gaming and quality-of-life features
- Game detection and Gaming Mode.
- Performance monitor.
- Translation, reader mode, picture-in-picture.
- CPU budget/affinity experiment; ship only if reliable and measurable.

## Build and repository policy

- Do not use GitHub Actions during normal development.
- Follow Mozilla's supported Windows build toolchain.
- Keep upstream source changes isolated and documented.
- Maintain a repeatable process for rebasing security fixes.
- Consider GitHub Actions only for the final installer/EXE build after explicit user approval.
