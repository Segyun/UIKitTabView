//
//  TabBarItem.swift
//  UIKitTabBar
//
//  Created by Huigyun Jeong on 10/2/26.
//

import SwiftUI

// MARK: - TabBarItem

@MainActor
public func TabBarItem<SelectionValue: Hashable, Content: View>(
    value: SelectionValue,
    title: String? = nil,
    icon: String,
    selectedIcon: String,
    @ViewBuilder content: @escaping () -> Content
) -> TabBarItemConfiguration<SelectionValue> {
    TabBarItemConfiguration(
        value: value,
        makeViewController: {
            let hostingController = UIHostingController(
                rootView: content()
            )

            configureTabBarItem(
                hostingController.tabBarItem,
                title: title,
                icon: icon,
                selectedIcon: selectedIcon
            )

            return hostingController
        },
        updateViewController: { viewController in
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
                icon: icon,
                selectedIcon: selectedIcon
            )

            return true
        }
    )
}

/// Creates an item for a tab bar that manages selection internally.
@MainActor
public func TabBarItem<Content: View>(
    title: String? = nil,
    icon: String,
    selectedIcon: String,
    @ViewBuilder content: @escaping () -> Content
) -> TabBarItemConfiguration<Int> {
    TabBarItem(
        value: 0,
        title: title,
        icon: icon,
        selectedIcon: selectedIcon,
        content: content
    )
}

// MARK: - Tab Bar Item Configuration

@MainActor
private func configureTabBarItem(
    _ item: UITabBarItem,
    title: String?,
    icon: String,
    selectedIcon: String
) {
    item.title = title
    item.image = UIImage(systemName: icon)
    item.selectedImage = UIImage(systemName: selectedIcon)
}
