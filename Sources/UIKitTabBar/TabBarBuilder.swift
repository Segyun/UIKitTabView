//
//  TabBarBuilder.swift
//  UIKitTabBar
//
//  Created by Huigyun Jeong on 10/2/26.
//

import SwiftUI

// MARK: - Builder

@resultBuilder
public struct TabBarBuilder<SelectionValue: Hashable> {
    public static func buildBlock(
        _ components: TabBarItemConfiguration<SelectionValue>...
    ) -> [TabBarItemConfiguration<SelectionValue>] {
        components
    }
}
