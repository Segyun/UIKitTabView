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
                "Home",
                image: "house",
                selectedImage: "house.fill",
                value: PreviewTab.home
            ) {
                Text("Home")
            }

            TabBarItem(
                "Search",
                image: "magnifyingglass",
                selectedImage: "magnifyingglass",
                value: PreviewTab.search
            ) {
                Text("Search")
            }

            TabBarItem(
                "Alerts",
                image: "bell",
                selectedImage: "bell.fill",
                value: PreviewTab.alerts
            ) {
                Text("Alerts")
            }

            TabBarItem(
                "Saved",
                image: "bookmark",
                selectedImage: "bookmark.fill",
                value: PreviewTab.saved
            ) {
                Text("Saved")
            }

            TabBarItem(
                "Profile",
                image: "person",
                selectedImage: "person.fill",
                value: PreviewTab.profile
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
        TabBarItem("Home", image: "house", selectedImage: "house.fill") {
            Text("Home")
        }
        TabBarItem("Search", image: "magnifyingglass", selectedImage: "magnifyingglass") {
            Text("Search")
        }
    }
}
