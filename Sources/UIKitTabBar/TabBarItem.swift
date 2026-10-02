//
//  TabBarItem.swift
//  UIKitTabBar
//
//  Created by Huigyun Jeong on 10/2/26.
//

import SwiftUI

/// A UIKit tab item that hosts SwiftUI content and optionally carries a selection value.
@MainActor
public struct TabBarItem<SelectionValue: Hashable> {
    public let value: SelectionValue?

    let makeViewController: () -> UIViewController
    let updateViewController: (UIViewController) -> Bool
}

extension TabBarItem {
    /// Creates a selection-valued item using UIKit images.
    @MainActor
    public init<S: StringProtocol, Content: View>(
        _ title: S,
        image: UIImage?,
        selectedImage: UIImage? = nil,
        value: SelectionValue,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            Optional(String(title)),
            image: image,
            selectedImage: selectedImage,
            value: .some(value),
            content: content
        )
    }

    /// Creates a selection-valued item using SF Symbols names.
    @MainActor
    public init<S: StringProtocol, Content: View>(
        _ title: S,
        image: String,
        selectedImage: String? = nil,
        value: SelectionValue,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            title,
            image: UIImage(systemName: image),
            selectedImage: selectedImage.flatMap { UIImage(systemName: $0) },
            value: value,
            content: content
        )
    }

    /// Creates a selection-valued item using UIKit images.
    @MainActor
    public init<Content: View>(
        image: UIImage?,
        selectedImage: UIImage? = nil,
        value: SelectionValue,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            nil,
            image: image,
            selectedImage: selectedImage,
            value: .some(value),
            content: content
        )
    }

    /// Creates a selection-valued item using SF Symbols names.
    @MainActor
    public init<Content: View>(
        image: String,
        selectedImage: String? = nil,
        value: SelectionValue,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            image: UIImage(systemName: image),
            selectedImage: selectedImage.flatMap { UIImage(systemName: $0) },
            value: value,
            content: content
        )
    }

    @MainActor
    private init<Content: View>(
        _ title: String?,
        image: UIImage?,
        selectedImage: UIImage?,
        value: SelectionValue?,
        content: @escaping () -> Content
    ) {
        self.value = value
        self.makeViewController = {
            let hostingController = UIHostingController(
                rootView: content()
            )

            configureTabBarItem(
                hostingController.tabBarItem,
                title: title,
                image: image,
                selectedImage: selectedImage
            )

            return hostingController
        }
        self.updateViewController = { viewController in
            guard
                let hostingController =
                    viewController as? UIHostingController<Content>
            else {
                return false
            }

            hostingController.rootView = content()

            configureTabBarItem(
                hostingController.tabBarItem,
                title: title,
                image: image,
                selectedImage: selectedImage
            )

            return true
        }
    }
}

extension TabBarItem where SelectionValue == Never {
    /// Creates an item without an external selection value using UIKit images.
    @MainActor
    public init<S: StringProtocol, Content: View>(
        _ title: S,
        image: UIImage?,
        selectedImage: UIImage? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            Optional(String(title)),
            image: image,
            selectedImage: selectedImage,
            value: nil,
            content: content
        )
    }

    /// Creates an item without an external selection value using SF Symbols names.
    @MainActor
    public init<S: StringProtocol, Content: View>(
        _ title: S,
        image: String,
        selectedImage: String? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            title,
            image: UIImage(systemName: image),
            selectedImage: selectedImage.flatMap { UIImage(systemName: $0) },
            content: content
        )
    }

    /// Creates an item without an external selection value using UIKit images.
    @MainActor
    public init<Content: View>(
        image: UIImage?,
        selectedImage: UIImage? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            nil,
            image: image,
            selectedImage: selectedImage,
            value: nil,
            content: content
        )
    }

    /// Creates an item without an external selection value using SF Symbols names.
    @MainActor
    public init<Content: View>(
        image: String,
        selectedImage: String? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            image: UIImage(systemName: image),
            selectedImage: selectedImage.flatMap { UIImage(systemName: $0) },
            content: content
        )
    }
}

// MARK: - Tab Bar Item Configuration

@MainActor
private func configureTabBarItem(
    _ item: UITabBarItem,
    title: String?,
    image: UIImage?,
    selectedImage: UIImage?
) {
    item.title = title
    item.image = image
    item.selectedImage = selectedImage
}
