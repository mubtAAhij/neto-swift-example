# Localization Files for zh-CN

This directory contains localization files for the zh-CN locale.

## Files
- `Localizable.strings`: Contains all localized strings for this locale

## Usage in Swift
To use these translations in your Swift code:

```swift
// Basic usage
let localizedString = NSLocalizedString("key", comment: "Optional comment")

// With SwiftUI
Text("key")

// With string interpolation
String(format: NSLocalizedString("Hello, %@!", comment: "Greeting"), name)
```

## Adding to Your Project
1. Add these files to your Xcode project
2. Make sure they are included in your target's "Copy Bundle Resources" build phase
3. Enable localization in your project settings
4. Set the "Localizations" build setting to include all supported locales

## Maintenance
These files are automatically generated and maintained by Quetzal.
Do not edit them manually as your changes will be overwritten.