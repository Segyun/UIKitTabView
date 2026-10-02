//
//  SelectionTests.swift
//  UIKitTabBar
//
//  Created by Huigyun Jeong on 10/2/26.
//

import SwiftUI
import Testing

@testable import UIKitTabBar

@Suite
@MainActor
struct SelectionTests {
    private enum Tab: Hashable {
        case home, search
    }

    @MainActor
    private final class SelectionState {
        var value: Tab = .search
        var writes = 0

        var binding: Binding<Tab> {
            Binding(
                get: { self.value },
                set: {
                    self.value = $0
                    self.writes += 1
                }
            )
        }
    }

    @MainActor
    private final class OptionalSelectionState {
        var value: Tab? = .home

        var binding: Binding<Tab?> {
            Binding(
                get: { self.value },
                set: { self.value = $0 }
            )
        }
    }

    private func makeView(_ state: SelectionState) -> TabBarControllerView<Tab> {
        TabBarControllerView(selection: state.binding) {
            TabBarItem(image: "house", selectedImage: "house.fill", value: Tab.home) {
                Text("Home")
            }
            TabBarItem(image: "magnifyingglass", selectedImage: "magnifyingglass", value: Tab.search)
            {
                Text("Search")
            }
        }
    }

    private func makeController() -> UITabBarController {
        let controller = UITabBarController()
        controller.viewControllers = [UIViewController(), UIViewController()]
        return controller
    }

    @Test
    func initialAndProgrammaticSelection() {
        let state = SelectionState()
        let coordinator = makeView(state).makeCoordinator()
        let controller = makeController()

        coordinator.applySelection(to: controller)
        #expect(controller.selectedIndex == 1)

        state.value = .home
        coordinator.applySelection(to: controller)
        #expect(controller.selectedIndex == 0)
        #expect(state.writes == 0)
    }

    @Test
    func userSelectionUpdatesBindingWithoutDuplicateWrites() {
        let state = SelectionState()
        let coordinator = makeView(state).makeCoordinator()
        let controller = makeController()
        let home = controller.viewControllers![0]

        coordinator.tabBarController(controller, didSelect: home)
        coordinator.tabBarController(controller, didSelect: home)

        #expect(state.value == .home)
        #expect(state.writes == 1)
    }

    @Test
    func coordinatorUsesLatestBindingAndTabOrder() {
        let oldState = SelectionState()
        let newState = SelectionState()
        let coordinator = makeView(oldState).makeCoordinator()
        let controller = makeController()
        let reordered = TabBarControllerView(selection: newState.binding) {
            TabBarItem(image: "magnifyingglass", selectedImage: "magnifyingglass", value: Tab.search)
            {
                Text("Search")
            }
            TabBarItem(image: "house", selectedImage: "house.fill", value: Tab.home) {
                Text("Home")
            }
        }

        coordinator.update(parent: reordered)
        coordinator.applySelection(to: controller)
        #expect(controller.selectedIndex == 0)

        coordinator.tabBarController(controller, didSelect: controller.viewControllers![1])
        #expect(newState.value == .home)
        #expect(oldState.value == .search)
        #expect(oldState.writes == 0)
    }

    @Test
    func missingSelectionAndUnknownControllerAreIgnored() {
        let state = SelectionState()
        let onlyHome = TabBarControllerView(selection: state.binding) {
            TabBarItem(image: "house", selectedImage: "house.fill", value: Tab.home) {
                Text("Home")
            }
        }
        let coordinator = onlyHome.makeCoordinator()
        let controller = UITabBarController()
        controller.viewControllers = [UIViewController()]

        coordinator.applySelection(to: controller)
        coordinator.tabBarController(controller, didSelect: UIViewController())

        #expect(controller.selectedIndex == 0)
        #expect(state.value == .search)
        #expect(state.writes == 0)
    }

    @Test
    func contentOnlyInitializerPreservesUserSelectionAcrossUpdates() {
        func makeUnboundView() -> TabBarControllerView<Never> {
            TabBarControllerView {
                TabBarItem(image: "house", selectedImage: "house.fill") {
                    Text("Home")
                }
                TabBarItem(image: "magnifyingglass", selectedImage: "magnifyingglass") {
                    Text("Search")
                }
            }
        }

        let coordinator = makeUnboundView().makeCoordinator()
        let controller = makeController()
        coordinator.applySelection(to: controller)
        #expect(controller.selectedIndex == 0)

        controller.selectedIndex = 1
        coordinator.tabBarController(controller, didSelect: controller.viewControllers![1])
        coordinator.update(parent: makeUnboundView())
        coordinator.applySelection(to: controller)

        #expect(controller.selectedIndex == 1)
    }

    @Test
    func optionalSelectionCanSelectATaggedNilValue() {
        let state = OptionalSelectionState()
        let view = TabBarControllerView(selection: state.binding) {
            TabBarItem(image: "house", selectedImage: "house.fill", value: Optional<Tab>.some(.home)) {
                Text("Home")
            }
            TabBarItem(image: "magnifyingglass", selectedImage: "magnifyingglass", value: Optional<Tab>.none) {
                Text("No selection value")
            }
        }
        let coordinator = view.makeCoordinator()
        let controller = makeController()

        state.value = nil
        coordinator.applySelection(to: controller)
        #expect(controller.selectedIndex == 1)

        coordinator.tabBarController(controller, didSelect: controller.viewControllers![0])
        #expect(state.value == .home)
        coordinator.tabBarController(controller, didSelect: controller.viewControllers![1])
        #expect(state.value == nil)
    }

}
