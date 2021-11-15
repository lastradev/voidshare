<div align="center">

<img src="https://i.imgur.com/ZjqWw5w.png" alt="app icon" height="150">  

# VoidShare

[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](CODE_OF_CONDUCT.md)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

A simple temporary file uploader using [0x0.st](https://0x0.st).

</div>

## Building from Source

1. If you don't have Flutter SDK installed, please visit official [Flutter](https://flutter.dev/) site.
2. Fetch latest source code from master branch.

```
$ git clone https://github.com/lastra-dev/void-share.git
```

3. Run the app with Android Studio or VS Code. Or run the command line:

```
$ flutter pub get
$ flutter run
```

## Contributing

Contributions are welcome. Please read our [contributing guidelines](CONTRIBUTING.md) before contributing.  
This is a work in progress, intended to be published as a CS50 final project while still being a FOSS project.

## Screenshots

<img src="https://i.imgur.com/bjqiWWT.png" alt="App overview" height="400">

## Development

If the `HistoryEntry` model gets changed, you should run:  
`$ flutter packages pub run build_runner build`  
to regenerate `HistoryEntryAdapter` class.
