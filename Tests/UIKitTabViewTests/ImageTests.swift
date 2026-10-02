//
//  ImageTests.swift
//  UIKitTabView
//
//  Created by Huigyun Jeong on 10/2/26.
//

import SwiftUI
import Testing

@testable import UIKitTabView

@Suite
@MainActor
struct ImageTests {
    private func makeImage(_ color: UIColor) -> UIImage {
        UIGraphicsImageRenderer(size: CGSize(width: 2, height: 2)).image { context in
            color.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 2, height: 2))
        }.withRenderingMode(.alwaysOriginal)
    }

    @Test
    func customImagesArePreservedDuringCreationAndUpdate() {
        let normal = makeImage(.red)
        let selected = makeImage(.blue)
        let original = UIKitTab("Home", image: normal, selectedImage: selected, value: "home") {
            Text("Home")
        }
        let controller = original.makeViewController()
        #expect(controller.tabBarItem.image === normal)
        #expect(controller.tabBarItem.selectedImage?.pngData() == selected.pngData())
        #expect(controller.tabBarItem.selectedImage?.renderingMode == .alwaysOriginal)
        #expect(controller.tabBarItem.image?.renderingMode == .alwaysOriginal)

        let replacement = UIKitTab("Updated", image: selected, selectedImage: normal, value: "home") {
            Text("Updated")
        }
        #expect(replacement.updateViewController(controller))
        #expect(controller.tabBarItem.title == "Updated")
        #expect(controller.tabBarItem.image === selected)
        #expect(controller.tabBarItem.selectedImage?.pngData() == normal.pngData())
    }

    @Test
    func unboundItemsAcceptCustomImages() {
        let image = makeImage(.green)
        let item: UIKitTab<Never> = UIKitTab("Home", image: image) {
            Text("Home")
        }
        let controller = item.makeViewController()
        #expect(controller.tabBarItem.image === image)
        #expect(controller.tabBarItem.selectedImage?.pngData() == image.pngData())
        #expect(controller.tabBarItem.selectedImage?.renderingMode == .alwaysOriginal)
    }

    @Test
    func symbolNamesResolveForBoundAndUnboundItems() {
        let bound = UIKitTab(image: "house", selectedImage: "house.fill", value: "home") {
            Text("Home")
        }
        let unbound = UIKitTab(image: "house", selectedImage: "house.fill") {
            Text("Home")
        }
        let basic = UIKitTab("Home", image: "house", value: "home") {
            Text("Home")
        }
        let basicController = basic.makeViewController()
        #expect(basicController.tabBarItem.title == "Home")
        #expect(basicController.tabBarItem.image != nil)
        #expect(basicController.tabBarItem.selectedImage != nil)
        #expect(basicController.tabBarItem.selectedImage?.size == basicController.tabBarItem.image?.size)

        for controller in [bound.makeViewController(), unbound.makeViewController()] {
            #expect(controller.tabBarItem.image?.isEqual(UIImage(systemName: "house")) == true)
            #expect(controller.tabBarItem.selectedImage?.isEqual(UIImage(systemName: "house.fill")) == true)
        }
    }

    @Test
    func absentAndInvalidImagesClearExistingImages() {
        let image = makeImage(.red)
        let original = UIKitTab(image: image, selectedImage: image) {
            Text("Home")
        }
        let controller = original.makeViewController()
        let noImages = UIKitTab(image: nil, selectedImage: nil) {
            Text("Home")
        }
        #expect(noImages.updateViewController(controller))
        #expect(controller.tabBarItem.image == nil)
        #expect(controller.tabBarItem.selectedImage == nil)

        #expect(original.updateViewController(controller))
        let invalidNames = UIKitTab(image: "invalid.symbol.for.testing", selectedImage: "invalid.symbol.for.testing") {
            Text("Home")
        }
        #expect(invalidNames.updateViewController(controller))
        #expect(controller.tabBarItem.image == nil)
        #expect(controller.tabBarItem.selectedImage == nil)
    }

    @Test
    func titlesAcceptSubstringsForAllImageOverloads() {
        let title = "prefix Home".dropFirst(7)
        let image = makeImage(.green)
        let controllers = [
            UIKitTab(title, image: image, value: "home") { Text("Home") }.makeViewController(),
            UIKitTab(title, image: image) { Text("Home") }.makeViewController(),
            UIKitTab(title, image: "house", value: "home") { Text("Home") }.makeViewController(),
            UIKitTab(title, image: "house") { Text("Home") }.makeViewController(),
        ]
        for controller in controllers {
            #expect(controller.tabBarItem.title == "Home")
        }
    }

}
