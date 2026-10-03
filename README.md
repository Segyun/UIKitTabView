# UIKitTabView

<p align="center">
  <img width="256" alt="Demo" src="https://github.com/user-attachments/assets/b216ad0b-82d6-4dca-972d-e6cd1cc6b50a" />
</p>

Use UIKit’s `UITabBarItem.selectedImage` in SwiftUI to give each tab a distinct image when selected.

UIKitTabView wraps `UITabBarController` and hosts SwiftUI content, with support for SF Symbols, custom `UIImage` instances, and optional selection bindings.

## Requirements

- iOS 13.0 or later.
- Swift tools version 6.0 or later.

## Installation

### Xcode

1. Choose **File > Add Package Dependencies**.
2. Enter `https://github.com/Segyun/UIKitTabView.git`.
3. Select **Up to Next Major Version** and enter `1.1.0`.
4. Add the `UIKitTabView` library product to your app target.

### Swift Package Manager

Add the dependency to your `Package.swift`:

```swift
.package(
    url: "https://github.com/Segyun/UIKitTabView.git",
    from: "1.1.0"
)
```

Then add the product to your target's dependencies:

```swift
.product(name: "UIKitTabView", package: "UIKitTabView")
```

## Selected tab images

Set `image` for the unselected tab and `selectedImage` for the selected tab. SF Symbols names are supported directly—for example, `house` becomes `house.fill` when selected.

Omit `selection` and item `value` arguments when UIKit should manage the selected tab.

```swift
import SwiftUI
import UIKitTabView

struct BasicTabs: View {
    var body: some View {
        UIKitTabView {
            UIKitTab(
                "Home",
                image: "house",
                selectedImage: "house.fill"
            ) {
                Text("Home")
            }

            UIKitTab(
                "Favorites",
                image: "star",
                selectedImage: "star.fill"
            ) {
                Text("Favorites")
            }
        }
    }
}
```

## Custom images

Pass `UIImage` instances to use asset catalog images or images created in code. Both parameters accept `nil` when no image is needed. `selectedImage` is optional; UIKit uses the normal image when it is omitted. To preserve an image's original colors, use `.alwaysOriginal` rendering mode.

```swift
UIKitTab(
    "Home",
    image: UIImage(named: "Home"),
    selectedImage: UIImage(named: "HomeSelected")
) {
    Text("Home")
}
```

Both SF Symbols and `UIImage` instances also work with selection bindings. Tab titles are optional.

## Selection binding

Pass a binding and give each tab a unique value of the same `Hashable` type. The initial binding selects the corresponding tab. Changing the binding switches tabs, and tapping a tab updates the binding.

```swift
import SwiftUI
import UIKitTabView

private enum AppTab: Hashable {
    case home, favorites
}

struct SelectableTabs: View {
    @State private var selection: AppTab = .home

    var body: some View {
        UIKitTabView(selection: $selection) {
            UIKitTab(
                "Home",
                image: "house",
                selectedImage: "house.fill",
                value: AppTab.home
            ) {
                Button("Go to Favorites") {
                    selection = .favorites
                }
            }

            UIKitTab(
                "Favorites",
                image: "star",
                selectedImage: "star.fill",
                value: AppTab.favorites
            ) {
                Text("Favorites")
            }
        }
    }
}
```

## Notes

- With a selection binding, provide a unique `value` for every item. An unmatched binding value leaves the current selection unchanged.
- The tab builder supports a fixed list of items; conditional tabs and loops are not supported.
- Changing the number or concrete content types of tabs can reset their local view state.

## License

UIKitTabView is available under the [MIT License](LICENSE).
