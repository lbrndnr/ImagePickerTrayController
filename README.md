# ImagePickerTrayController

[![Twitter: @lbrndnr](https://img.shields.io/badge/contact-@lbrndnr-blue.svg?style=flat)](https://twitter.com/lbrndnr)
[![License](http://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/lbrndnr/ImagePickerTrayController/blob/master/LICENSE)

## About
ImagePickerTrayController is a component that replicates the custom photo action sheet in iMessage. It's the iOS 10 version of  [ImagePickerSheetController](https://github.com/lbrndnr/ImagePickerSheetController). 
⚠️Note that this library is still WIP⚠️

<img src="https://raw.githubusercontent.com/lbrndnr/ImagePickerTrayController/master/Screenshots/Example.png" width="320">

### Example

```swift
let controller = ImagePickerTrayController()
controller.add(action: .cameraAction { _ in
    print("Show Camera")
})
controller.add(action: .libraryAction { _ in
    print("Show Library")
})
controller.show(in: view)
imagePickerTrayController = controller
```

## Installation

I wouldn't recommend using this library just yet. It's still WIP⚠️.

## Requirements
`ImagePickerTrayController` is written in Swift and links against `Photos.framework`. It therefore requires iOS 8 or later.

## Author
I'm Laurin Brandner, I'm on [Twitter](https://twitter.com/lbrndnr).

## License
`ImagePickerTrayController` is licensed under the [MIT License](http://opensource.org/licenses/mit-license.php).
