NativeDrag
==========

> **⚠️ This repository is archived and no longer maintained.**
> It relies on the legacy `WebView` API which has been deprecated by Apple and removed in modern macOS versions.

A sample macOS application demonstrating HTML5 native drag-and-drop interoperability with native AppKit controls.

## Overview

NativeDrag shows how to bridge drag-and-drop between a native `NSTableView` and a `WebView` (legacy WebKit) displaying an HTML5 page. It was written for macOS (OS X) as a proof-of-concept for sharing custom pasteboard types across the native/web boundary.

Features:
- Drag song items from a native `NSTableView` and drop them into an HTML5 list rendered inside a `WebView`
- Drag song items from the HTML5 list and drop them back into the native `NSTableView`
- Custom pasteboard type (`net.zonble.songobejct`) used to carry structured JSON data between the two sides

## Requirements

- macOS 10.7 or later (legacy; uses the deprecated `WebView` / `WebKit.framework` API)
- Xcode 4 or later

## Notes

This project uses the legacy `WebView` class from `WebKit.framework`, which Apple deprecated in macOS 10.14 (Mojave) and has since removed. It will **not** build or run on modern macOS versions without significant refactoring to use `WKWebView`.

This repository is kept for historical reference only.