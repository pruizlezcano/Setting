//
//  SettingExtensions.swift
//  Setting
//
//  Created by A. Zheng (github.com/aheze) on 2/22/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import SwiftUI

extension Range<String.Index> {
    func attributedRange(for attributedString: AttributedString) -> Range<AttributedString.Index>? {
        let start = AttributedString.Index(lowerBound, within: attributedString)
        let end = AttributedString.Index(upperBound, within: attributedString)

        guard let start, let end else { return nil }
        let attributedRange = start ..< end
        return attributedRange
    }
}

/// From https://stackoverflow.com/a/32306142/14351818
extension StringProtocol {
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
              let range = self[startIndex...]
              .range(of: string, options: options)
        {
            result.append(range)
            startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}

public extension CGFloat {
    static var settingIconCornerRadius: CGFloat {
        if #available(iOS 26.0, macOS 26.0, *) {
            return 7
        }
        return 6
    }

    static var settingGroupCornerRadius: CGFloat {
        if #available(iOS 26.0, macOS 26.0, *) {
            return 24
        }
        return 12
    }

    static var settingDefaultEdgePadding: CGFloat {
        if #available(iOS 26.0, macOS 26.0, *) {
            return 14
        }
        return 20
    }

    static var settingSmallEdgePadding: CGFloat {
        if #available(iOS 26.0, macOS 26.0, *) {
            return 14
        }
        return 16
    }

    static var settingRowVerticalPadding: CGFloat {
        if #available(iOS 26.0, macOS 26.0, *) {
            return 14
        }
        return 14
    }

    static var settingSliderVerticalPadding: CGFloat {
        if #available(iOS 26.0, macOS 26.0, *) {
            return 10
        }
        return 8
    }

    static var settingSectionVerticalPadding: CGFloat {
        if #available(iOS 26.0, macOS 26.0, *) {
            return 8
        }
        return 6
    }
}
