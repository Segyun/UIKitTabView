//
//  LocalizedStringResourceTests.swift
//  UIKitTabViewTests
//
//  Created by Huigyun Jeong on 10/3/26.
//

import SwiftUI
import Testing

@testable import UIKitTabView

@Suite
@MainActor
struct LocalizedStringResourceTests {
    private func makeImage(_ color: UIColor) -> UIImage {
        UIGraphicsImageRenderer(size: CGSize(width: 2, height: 2)).image { context in
            color.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 2, height: 2))
        }.withRenderingMode(.alwaysOriginal)
    }

    @Test
    func boundItemWithLocalizedStringResourceAndUIImage() {
        guard #available(iOS 16, *) else { return }
        let image = makeImage(.red)
        let selected = makeImage(.blue)
        let resource = LocalizedStringResource("Favorites")

        let tab = UIKitTab(
            resource,
            image: image,
            selectedImage: selected,
            value: "favorites"
        ) {
            Text("Favorites")
        }

        let controller = tab.makeUIViewController(environment: .init())
        #expect(controller.tabBarItem.title == "Favorites")
        #expect(controller.tabBarItem.image === image)
        #expect(controller.tabBarItem.selectedImage?.pngData() == selected.pngData())
    }

    @Test
    func boundItemWithLocalizedStringResourceAndSFName() {
        guard #available(iOS 16, *) else { return }
        let resource = LocalizedStringResource("Home")

        let tab = UIKitTab(
            resource,
            image: "house",
            selectedImage: "house.fill",
            value: "home"
        ) {
            Text("Home")
        }

        let controller = tab.makeUIViewController(environment: .init())
        #expect(controller.tabBarItem.title == "Home")
        #expect(controller.tabBarItem.image?.isEqual(UIImage(systemName: "house")) == true)
        #expect(controller.tabBarItem.selectedImage?.isEqual(UIImage(systemName: "house.fill")) == true)
    }

    @Test
    func unboundItemWithLocalizedStringResourceAndUIImage() {
        guard #available(iOS 16, *) else { return }
        let image = makeImage(.green)
        let resource = LocalizedStringResource("Settings")

        let tab: UIKitTab<Never> = UIKitTab(
            resource,
            image: image
        ) {
            Text("Settings")
        }

        let controller = tab.makeUIViewController(environment: .init())
        #expect(controller.tabBarItem.title == "Settings")
        #expect(controller.tabBarItem.image === image)
    }

    @Test
    func unboundItemWithLocalizedStringResourceAndSFName() {
        guard #available(iOS 16, *) else { return }
        let resource = LocalizedStringResource("Profile")

        let tab: UIKitTab<Never> = UIKitTab(
            resource,
            image: "person",
            selectedImage: "person.fill"
        ) {
            Text("Profile")
        }

        let controller = tab.makeUIViewController(environment: .init())
        #expect(controller.tabBarItem.title == "Profile")
        #expect(controller.tabBarItem.image?.isEqual(UIImage(systemName: "person")) == true)
        #expect(controller.tabBarItem.selectedImage?.isEqual(UIImage(systemName: "person.fill")) == true)
    }

    @Test
    func updateViewControllerWithLocalizedStringResource() {
        guard #available(iOS 16, *) else { return }
        let original = UIKitTab(
            LocalizedStringResource("First"),
            image: "1.circle",
            value: 1
        ) {
            Text("First")
        }
        let controller = original.makeUIViewController(environment: .init())
        #expect(controller.tabBarItem.title == "First")

        let updated = UIKitTab(
            LocalizedStringResource("Second"),
            image: "2.circle",
            value: 1
        ) {
            Text("Second")
        }
        #expect(updated.updateUIViewController(controller, environment: .init()))
        #expect(controller.tabBarItem.title == "Second")
    }

    @Test
    func environmentLocaleResolvesDuringMakeAndUpdate() {
        guard #available(iOS 16, *) else { return }
        let resource = LocalizedStringResource("Hello")

        let tab = UIKitTab(
            resource,
            image: "globe",
            value: "test"
        ) {
            Text("Content")
        }

        var env = EnvironmentValues()
        env.locale = Locale(identifier: "fr_FR")

        let controller = tab.makeUIViewController(environment: env)
        #expect(controller.tabBarItem.title == "Hello")

        var newEnv = EnvironmentValues()
        newEnv.locale = Locale(identifier: "ko_KR")
        #expect(tab.updateUIViewController(controller, environment: newEnv))
        #expect(controller.tabBarItem.title == "Hello")
    }
}
