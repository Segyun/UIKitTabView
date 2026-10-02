//
//  TabBarItemConfiguration.swift
//  UIKitTabBar
//
//  Created by Huigyun Jeong on 10/2/26.
//

import SwiftUI

// MARK: - Configuration

@MainActor
public struct TabBarItemConfiguration<SelectionValue: Hashable> {
    public let value: SelectionValue

    let makeViewController: () -> UIViewController

    let updateViewController: (UIViewController) -> Bool
}
