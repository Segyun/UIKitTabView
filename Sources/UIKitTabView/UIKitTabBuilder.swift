//
//  UIKitTabBuilder.swift
//  UIKitTabView
//
//  Created by Huigyun Jeong on 10/2/26.
//

import SwiftUI

// MARK: - Builder

@resultBuilder
public struct UIKitTabBuilder<SelectionValue: Hashable> {
    public static func buildBlock(
        _ components: UIKitTab<SelectionValue>...
    ) -> [UIKitTab<SelectionValue>] {
        components
    }
}
