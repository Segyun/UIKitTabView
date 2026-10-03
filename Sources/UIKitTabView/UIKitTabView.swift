//
//  UIKitTabView.swift
//  UIKitTabView
//
//  Created by Huigyun Jeong on 10/2/26.
//

import SwiftUI

@MainActor
public struct UIKitTabView<SelectionValue: Hashable>: UIViewControllerRepresentable {
    private let selection: Binding<SelectionValue>?
    private let tabs: [UIKitTab<SelectionValue>]

    /// Creates tabs whose unique values are synchronized with the selection binding.
    /// A selection without a matching tab leaves UIKit's current selection unchanged.
    public init(
        selection: Binding<SelectionValue>,
        @UIKitTabBuilder<SelectionValue> content: () -> [UIKitTab<SelectionValue>]
    ) {
        self.selection = selection
        self.tabs = content()
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    public func makeUIViewController(context: Context) -> UITabBarController {
        let tabBarController: UITabBarController = .init()
        tabBarController.delegate = context.coordinator
        tabBarController.viewControllers = tabs
            .map { $0.makeUIViewController(environment: context.environment) }
        context.coordinator.applySelection(to: tabBarController)
        return tabBarController
    }

    public func updateUIViewController(
        _ tabBarController: UITabBarController,
        context: Context
    ) {
        context.coordinator.update(parent: self)
        updateTabs(in: tabBarController, context: context)
        context.coordinator.applySelection(to: tabBarController)
    }

    public static func dismantleUIViewController(
        _ tabBarController: UITabBarController,
        coordinator: Coordinator
    ) {
        tabBarController.delegate = nil
    }

    private func updateTabs(in tabBarController: UITabBarController, context: Context) {
        guard
            let viewControllers = tabBarController.viewControllers,
            viewControllers.count == tabs.count
        else {
            tabBarController.viewControllers = tabs.map { $0.makeUIViewController(environment: context.environment) }
            return
        }

        for (viewController, tab) in zip(viewControllers, tabs) {
            if !tab.updateUIViewController(viewController, environment: context.environment) {
                tabBarController.viewControllers = tabs.map { $0.makeUIViewController(environment: context.environment) }
                return
            }
        }
    }

    @MainActor
    public final class Coordinator: NSObject, UITabBarControllerDelegate {
        private var parent: UIKitTabView

        fileprivate init(parent: UIKitTabView) {
            self.parent = parent
        }

        func update(parent: UIKitTabView) {
            self.parent = parent
        }

        func applySelection(to tabBarController: UITabBarController) {
            guard
                let selection = parent.selection,
                let index = parent.tabs.firstIndex(where: { $0.value == .some(selection.wrappedValue) }),
                let viewControllers = tabBarController.viewControllers,
                viewControllers.indices.contains(index),
                tabBarController.selectedIndex != index
            else {
                return
            }

            tabBarController.selectedIndex = index
        }

        public func tabBarController(
            _ tabBarController: UITabBarController,
            didSelect viewController: UIViewController
        ) {
            guard
                let selection = parent.selection,
                let index = tabBarController.viewControllers?.firstIndex(where: {
                    $0 === viewController
                }),
                parent.tabs.indices.contains(index)
            else {
                return
            }

            guard let value = parent.tabs[index].value else {
                return
            }
            if selection.wrappedValue != value {
                selection.wrappedValue = value
            }
        }
    }
}

extension UIKitTabView where SelectionValue == Never {
    /// Creates tabs without an external selection binding.
    public init(
        @UIKitTabBuilder<Never> content: () -> [UIKitTab<Never>]
    ) {
        self.selection = nil
        self.tabs = content()
    }
}
