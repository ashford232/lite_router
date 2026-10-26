
## 0.1.0

- Initial release of LiteRouter.
- Provide lightweight Flutter navigation.
- Support pushing, replacing, and clearing routes.
- Support back navigation and route result values.

## 0.1.1

- Add an example application.
- Improve public API documentation.
- Use the MIT license.

## 0.1.2

### Added
- Added `BuildContext` navigation extensions: `context.push()`, `context.replace()`, `context.to()`, `context.back()`, `context.canPop()`, and `context.maybeBack()`.
- Added built-in transition presets: slide, fade, scale, fade-slide, and slide-up.
- Added support for custom transition builders and per-navigation transition overrides.
- Added an example demonstrating built-in and custom transitions.

### Improved
- Added configurable transition durations with a default of 300 milliseconds.
- Improved navigation API usability and documentation.