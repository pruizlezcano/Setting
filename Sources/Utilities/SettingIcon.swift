//
//  SettingIcon.swift
//  Setting
//
//  Created by A. Zheng (github.com/aheze) on 2/21/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import SwiftUI

/**
 An general purpose icon view.
 */
public enum SettingIcon {
    case system(icon: String, foregroundColor: Color = .white, backgroundColor: Color)

    /// Pass in a `foregroundColor` to render and recolor the image as a template.
    case image(name: String, inset: CGFloat, foregroundColor: Color?, backgroundColor: Color)
    case custom(view: AnyView)
}

/**
 A view for displaying a `SettingIcon`.
 */
public struct SettingIconView: View {
    public var icon: SettingIcon

    public init(icon: SettingIcon) {
        self.icon = icon
    }

    public var body: some View {
        switch icon {
        case let .system(icon, foregroundColor, backgroundColor):
            Image(systemName: icon)
                .foregroundColor(foregroundColor)
                .font(.footnote)
                .frame(width: 28, height: 28)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: .settingIconCornerRadius))

        case let .image(name, inset, foregroundColor, backgroundColor):
            if let foregroundColor {
                Image(name)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(foregroundColor)
                    .aspectRatio(contentMode: .fit)
                    .padding(inset)
                    .frame(width: 28, height: 28)
                    .background(backgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: .settingIconCornerRadius))
            } else {
                Image(name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(inset)
                    .frame(width: 28, height: 28)
                    .background(backgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: .settingIconCornerRadius))
            }

        case let .custom(anyView):
            anyView
        }
    }
}
