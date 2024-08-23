<div align="center">
<img src="https://i.imgur.com/HRUd6lq.png" alt="app icon" height="120">  

## **Simple & Libre Temporary File Uploader.**

[![made-with-flutter](https://img.shields.io/badge/Made%20with-Flutter-1f425f.svg)](https://flutter.dev/)
![Release](https://img.shields.io/github/v/release/lastra-dev/void-share)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](CODE_OF_CONDUCT.md)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

VoidShare is a simple temporary file uploader using [0x0](https://voidshare.xyz) backend, made with Flutter 💙.

</div>

## Features

*   👌 Single file upload.
*   🚀 Multiple file upload with Zip compression.
*   🔭 File preview with remove option.
*   💯 Upload progress and cancel option.
*   🍯 Upload History.
*   😄 No registration.
*   😍 No ads.

## Screenshots

<img src="https://i.imgur.com/bjqiWWT.png" alt="App overview" height="400">

## Building from Source

1.  If you don't have Flutter SDK installed, please visit the official [Flutter](https://flutter.dev/) site.
2.  Fetch the latest source code from the master branch.

```bash
$ git clone https://github.com/lastra-dev/void-share.git
```

3.  Run the app with Android Studio or VS Code. Or run the command line:

```bash
$ flutter pub get
$ flutter run
```

## Contributing

Contributions are welcome. Please read our [contributing guidelines](CONTRIBUTING.md) before contributing.

## Development

### Testing Responsivness

You can test this app on different screen sizes with [device preview](https://pub.dev/packages/device_preview),
already added to [dev\_dependencies](pubspec.yaml#L36).

### History Entry Adapater

If the `HistoryEntry` model gets changed, you should run:

    $ flutter packages pub run build_runner build

to regenerate `HistoryEntryAdapter` class.
