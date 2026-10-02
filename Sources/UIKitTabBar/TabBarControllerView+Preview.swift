//
//  TabBarControllerView+Preview.swift
//  UIKitTabBar
//
//  Created by Huigyun Jeong on 10/2/26.
//

import SwiftUI

private enum PreviewTab: Hashable {
    case home, search, alerts, saved, profile
}

@available(iOS 15.0, *)
private struct TabBarPreview: View {
    @State private var selection: PreviewTab = .search

    var body: some View {
        TabBarControllerView(selection: $selection) {
            TabBarItem(
                value: PreviewTab.home,
                title: "Home",
                icon: "house",
                selectedIcon: "house.fill"
            ) {
                Text("Home")
            }

            TabBarItem(
                value: PreviewTab.search,
                title: "Search",
                icon: "magnifyingglass",
                selectedIcon: "magnifyingglass"
            ) {
                Text("Search")
            }

            TabBarItem(
                value: PreviewTab.alerts,
                title: "Alerts",
                icon: "bell",
                selectedIcon: "bell.fill"
            ) {
                Text("Alerts")
            }

            TabBarItem(
                value: PreviewTab.saved,
                title: "Saved",
                icon: "bookmark",
                selectedIcon: "bookmark.fill"
            ) {
                Text("Saved")
            }

            TabBarItem(
                value: PreviewTab.profile,
                title: "Profile",
                icon: "person",
                selectedIcon: "person.fill"
            ) {
                Text("Profile")
            }
        }
        .ignoresSafeArea(.container)
        .tint(.yellow)
    }
}

@available(iOS 15.0, *)
#Preview {
    TabBarPreview()
}

#Preview("Without selection") {
    TabBarControllerView {
        TabBarItem(title: "Home", icon: "house", selectedIcon: "house.fill") {
            Text("Home")
        }
        TabBarItem(title: "Search", icon: "magnifyingglass", selectedIcon: "magnifyingglass") {
            Text("Search")
        }
    }
}
