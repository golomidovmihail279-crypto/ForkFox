# Initial architecture

Status: proposed foundation, subject to prototype validation

## Platform and language

- Windows 11 x64.
- Native Windows host, initially C++20 / Win32.
- Microsoft Edge WebView2 SDK for web content.
- Keep native browser chrome separate from web content so the browser UI does not require a second hidden web application.
- Avoid Electron, Node.js, bundled Chromium, background daemons, and large UI frameworks in the first prototype.

## High-level components

1. **Native shell** — main window, tabs, address bar, menus, sidebar, settings, keyboard shortcuts.
2. **Web runtime adapter** — creates and manages WebView2 environments/controllers; hides WebView2-specific details from the rest of the app.
3. **Profile manager** — separate local data directories and WebView2 profile contexts; no cloud sync.
4. **Navigation/security layer** — URL validation, popup policy, request filtering, download handling, phishing-warning integration.
5. **Privacy/filter engine** — local filter lists, request classification, per-site allowlist, update scheduler that sleeps when idle.
6. **Credential vault** — encrypted records, master-password flow, OS-protected key material, import/export.
7. **Session recovery** — crash-only recovery journal; normal close clears the recovery marker.
8. **Gaming controller** — optional process detection and low-priority background scheduling; no game injection.
9. **Settings store** — small versioned local configuration file.
10. **Update checker** — optional notification-only check; installation requires user approval.

## Resource rules

- No periodic polling when there is no work to do.
- Prefer event-driven APIs and OS notifications.
- No telemetry by default.
- No background task should keep a profile or renderer alive without a user-visible reason.
- Defer noncritical work while a detected game is active.
- Measure each feature's memory/CPU cost before enabling it by default.
- Do not spawn a separate process for a feature that can safely live in the native host.

## Security rules

- Web content must remain sandboxed by the browser runtime; do not disable WebView2 security features to gain performance.
- Never expose native host objects to arbitrary websites.
- Use strict origin checks for any host/web messaging.
- Keep profile storage separated.
- Store secrets encrypted at rest; never log passwords, cookies, tokens, or raw imported CSV data.
- Treat imported files and filter lists as untrusted input.
- Verify update signatures and package integrity before offering installation.

## Implementation sequence

### Phase 0 — foundation
- Native Win32 window and WebView2 initialization.
- Runtime detection and helpful missing-runtime message.
- One tab, address bar, navigation, and clean shutdown.
- Resource benchmark harness and baseline report.

### Phase 1 — browser basics
- Multi-tab and multi-window management.
- Search provider selection.
- Configurable start page, bookmarks, theme, and shortcuts.
- Download manager.

### Phase 2 — privacy and profiles
- Profile isolation.
- Ad/tracker blocking and popup policy.
- Clear-on-exit controls.
- Crash-only session recovery.
- Phishing protection after provider and licensing review.

### Phase 3 — credentials and backup
- Encrypted password vault.
- Chrome/Firefox import and encrypted export.
- Encrypted profile backup/restore.
- Security review before release.

### Phase 4 — optional gaming and quality-of-life features
- Game detection and Gaming Mode.
- Performance monitor.
- Translation, reader mode, picture-in-picture.
- CPU budget/affinity experiment; ship only if reliable and measurable.

## Build and repository policy

- No GitHub Actions during normal development.
- Build locally with documented Visual Studio Build Tools / Windows SDK requirements.
- Use a separate development branch and review before merging to main.
- Consider GitHub Actions only for the final EXE/installer build after explicit user approval.
