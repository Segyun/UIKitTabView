//
//  UIKitTab.swift
//  UIKitTabView
//
//  Created by Huigyun Jeong on 10/2/26.
//

import SwiftUI

/// A UIKit tab item that hosts SwiftUI content and optionally carries a selection value.
@MainActor
public struct UIKitTab<SelectionValue: Hashable>: UIViewControllerRepresentable {
    public let value: SelectionValue?

    private let _makeUIViewController: (EnvironmentValues) -> UIViewController
    private let _updateUIViewController: (UIViewController, EnvironmentValues) -> Bool

    @MainActor
    private init<Content: View>(
        title: @escaping (EnvironmentValues) -> String?,
        image: UIImage?,
        selectedImage: UIImage?,
        value: SelectionValue?,
        content: @escaping () -> Content
    ) {
        self.value = value
        self._makeUIViewController = { environment in
            let hostingController: UIHostingController = .init(
                rootView: content()
            )

            configureTabBarItem(
                hostingController.tabBarItem,
                title: title(environment),
                image: image,
                selectedImage: selectedImage
            )

            return hostingController
        }
        self._updateUIViewController = { viewController, environment in
            guard
                let hostingController =
                    viewController as? UIHostingController<Content>
            else {
                return false
            }

            hostingController.rootView = content()

            configureTabBarItem(
                hostingController.tabBarItem,
                title: title(environment),
                image: image,
                selectedImage: selectedImage
            )

            return true
        }
    }

    public func makeUIViewController(context: Context) -> UIViewController {
        return makeUIViewController(environment: context.environment)
    }

    func makeUIViewController(environment: EnvironmentValues) -> UIViewController {
        return _makeUIViewController(environment)
    }

    public func updateUIViewController(
        _ uiViewController: UIViewController,
        context: Context
    ) {
        updateUIViewController(
            uiViewController,
            environment: context.environment
        )
    }

    @discardableResult
    func updateUIViewController(
        _ uiViewController: UIViewController,
        environment: EnvironmentValues
    ) -> Bool {
        return _updateUIViewController(uiViewController, environment)
    }
}

extension UIKitTab {
    /// Creates a selection-valued item using UIKit images.
    @MainActor
    public init<S: StringProtocol, Content: View>(
        _ title: S,
        image: UIImage?,
        selectedImage: UIImage? = nil,
        value: SelectionValue,
        @ViewBuilder content: @escaping () -> Content
    ) {
        let titleString = String(title)
        self.init(
            title: { _ in titleString },
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
            title: { _ in nil },
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
}

@available(iOS 16, *)
extension UIKitTab {
    /// Creates a selection-valued item using a localized string resource and UIKit images.
    @MainActor
    public init<Content: View>(
        _ titleResource: LocalizedStringResource,
        image: UIImage?,
        selectedImage: UIImage? = nil,
        value: SelectionValue,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            title: { environment in
                var resource = titleResource
                resource.locale = environment.locale
                return String(localized: resource)
            },
            image: image,
            selectedImage: selectedImage,
            value: .some(value),
            content: content
        )
    }

    /// Creates a selection-valued item using a localized string resource and SF Symbols names.
    @MainActor
    public init<Content: View>(
        _ titleResource: LocalizedStringResource,
        image: String,
        selectedImage: String? = nil,
        value: SelectionValue,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            titleResource,
            image: UIImage(systemName: image),
            selectedImage: selectedImage.flatMap { UIImage(systemName: $0) },
            value: value,
            content: content
        )
    }
}

extension UIKitTab where SelectionValue == Never {
    /// Creates an item without an external selection value using UIKit images.
    @MainActor
    public init<S: StringProtocol, Content: View>(
        _ title: S,
        image: UIImage?,
        selectedImage: UIImage? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        let titleString = String(title)
        self.init(
            title: { _ in titleString },
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
            title: { _ in nil },
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

@available(iOS 16, *)
extension UIKitTab where SelectionValue == Never {
    /// Creates an item without an external selection value using a localized string resource and UIKit images.
    @MainActor
    public init<Content: View>(
        _ titleResource: LocalizedStringResource,
        image: UIImage?,
        selectedImage: UIImage? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            title: { environment in
                var resource = titleResource
                resource.locale = environment.locale
                return String(localized: resource)
            },
            image: image,
            selectedImage: selectedImage,
            value: nil,
            content: content
        )
    }

    /// Creates an item without an external selection value using a localized string resource and SF Symbols names.
    @MainActor
    public init<Content: View>(
        _ titleResource: LocalizedStringResource,
        image: String,
        selectedImage: String? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            titleResource,
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
