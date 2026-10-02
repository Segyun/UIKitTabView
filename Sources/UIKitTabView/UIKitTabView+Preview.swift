//
//  UIKitTabView+Preview.swift
//  UIKitTabView
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
        UIKitTabView(selection: $selection) {
            UIKitTab(
                "Home",
                image: "house",
                selectedImage: "house.fill",
                value: PreviewTab.home
            ) {
                Text("Home")
            }

            UIKitTab(
                "Search",
                image: "magnifyingglass",
                selectedImage: "magnifyingglass",
                value: PreviewTab.search
            ) {
                Text("Search")
            }

            UIKitTab(
                "Alerts",
                image: "bell",
                selectedImage: "bell.fill",
                value: PreviewTab.alerts
            ) {
                Text("Alerts")
            }

            UIKitTab(
                "Saved",
                image: "bookmark",
                selectedImage: "bookmark.fill",
                value: PreviewTab.saved
            ) {
                Text("Saved")
            }

            UIKitTab(
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
    UIKitTabView {
        UIKitTab("Home", image: "house", selectedImage: "house.fill") {
            Text("Home")
        }
        UIKitTab("Search", image: "magnifyingglass", selectedImage: "magnifyingglass") {
            Text("Search")
        }
    }
}
