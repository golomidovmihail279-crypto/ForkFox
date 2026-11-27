# ForkFox product specification

Status: initial requirements baseline  
Platform: Windows 11 x64 only  
Engine: direct Chromium source fork

## Product goal

A modern gaming-oriented browser that remains resource-efficient during ordinary browsing, not only while a game is running. "Zero resource use" is impossible; the goal is to minimize the browser's own idle overhead and avoid unnecessary background work.

ForkFox is its own browser product with its own identity, interface, settings, defaults, profiles, and optional gaming features. Chromium is the underlying open-source engine/browser platform, not the product design to be copied.

## Core experience

- Modern gaming-style interface with a configurable sidebar.
- Tabs, address bar, navigation controls, and multiple browser windows.
- Configurable start page: users choose which widgets/elements appear. Default is search plus quick links.
- Search providers: DuckDuckGo and Google, selectable by the user.
- Theme follows Windows 11 light/dark mode automatically; manual override is available.
- Quick links and configurable bookmarks, including optional bookmark bar, folders, sorting, and drag-and-drop.
- Google sign-in on websites works through normal website authentication. No ForkFox account and no Chrome Sync.
- No browser extensions.
- No built-in VPN.

## Resource and gaming behavior

- Low-overhead behavior is always active: avoid unnecessary background services, polling, animations, telemetry, and background tasks.
- Discard/suspend eligible inactive tabs when safe; restore them on demand.
- Optional Gaming Mode can reduce nonessential background activity.
- Optional automatic game detection for Steam and other launchers; users can disable automatic detection and switch Gaming Mode manually.
- Do not inject into games, interfere with anti-cheat, or change game process behavior.
- Optional performance monitor (off by default): RAM, CPU, process count, and per-tab resource estimates where available.
- CPU/core control is a research item. UI may offer a safe CPU budget/affinity control only after validating that the whole Chromium process tree can be controlled correctly. Do not label a percentage cap as an exact core count.

## Privacy and security

- Powerful built-in ad, tracker, and popup blocking, with configurable protection level and per-site allowlist.
- Filter-list updates must be controlled and lightweight; blocking must not silently disable site security or break essential authentication.
- Warnings for known phishing and malicious sites, using a maintained threat source after feasibility and licensing review.
- Optional clear-on-exit settings for history, cookies/site data, cache, temporary files, form data, and sessions. Saved password vault data is never cleared by this feature.
- Local profile data only; no cloud sync.
- Separate browser profiles with isolated cookies, site storage, settings, bookmarks, and password vaults.
- Encrypted local password vault with master-password protection and secure operating-system integration.
- Import passwords from Chrome and Firefox, including common CSV exports. Warn that CSV exports are plaintext; never retain the source file or create unencrypted copies.
- Encrypted password export and encrypted profile backup.
- Backup/restore profile data in one encrypted file, protected by a user-chosen password.
- Google website authentication is supported; Google Chrome profile synchronization is not.
- Recovery prompt only after an abnormal crash. Normal exit must not restore the previous session.

## Optional features

- Built-in page translator with language selection and per-site controls.
- Reader mode, manually enabled or optionally offered on article pages.
- Picture-in-picture video window.
- Performance monitor.
- Optional automatic cleanup on exit, configurable by data category.
- Optional gaming mode and automatic game detection.
- Optional bookmark bar and start-page widgets.
- Manual theme override.
- Configurable keyboard shortcuts with conflict warnings.
- Configurable multi-window behavior.

## Downloads and updates

- Built-in download manager: queue, progress, speed, pause/resume where supported, cancel, history, and configurable download folder.
- Update checking can be disabled.
- When enabled, ForkFox only notifies and offers an update. It never installs an update without explicit user approval.
- Chromium security updates must be tracked and integrated promptly; the notification-only installation policy does not justify delaying critical security fixes.

## Accessibility and customization

- User-configurable hotkeys, with conflict detection.
- User can enable/disable configurable start-page elements and optional browser features.
- Sidebar contents and layout are configurable.

## Non-goals

- Windows 10 support.
- Browser extensions.
- VPN.
- ForkFox account or cloud synchronization.
- Google Chrome Sync.
- Background auto-installation of updates.
- Unnecessary telemetry or always-running helper services.
- Rewriting a modern browser engine from scratch.

## Product quality gates

- Measure idle RAM/CPU before and after each major subsystem.
- Keep optional features off by default unless essential for safe operation.
- No password or profile-backup feature ships without a security review.
- No resource-saving feature may break normal browsing, video playback, downloads, or site authentication without a clear user-visible setting.
- No public release without a documented and tested Chromium security-update process.
