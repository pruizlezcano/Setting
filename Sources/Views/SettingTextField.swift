//
//  SettingTextField.swift
//  Setting
//
//  Created by A. Zheng (github.com/aheze) on 2/24/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import SwiftUI

/**
 A text field.
 */
public struct SettingTextField: View, Setting {
    public var id: AnyHashable?
    public var placeholder: String
    @Binding public var text: String
    public var verticalPadding = CGFloat.settingRowVerticalPadding
    public var horizontalPadding: CGFloat?

    public init(
        id: AnyHashable? = nil,
        placeholder: String,
        text: Binding<String>,
        verticalPadding: CGFloat = CGFloat.settingRowVerticalPadding,
        horizontalPadding: CGFloat? = nil
    ) {
        self.id = id
        self.placeholder = placeholder
        _text = text
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
    }

    public var body: some View {
        SettingTextFieldView(
            placeholder: placeholder,
            text: $text,
            verticalPadding: verticalPadding,
            horizontalPadding: horizontalPadding
        )
        .id(identifier)
        .highlightIfTargeted(id: identifier)
    }
}

struct SettingTextFieldView: View {
    @Environment(\.edgePadding) var edgePadding

    let placeholder: String
    @Binding var text: String

    var verticalPadding = CGFloat.settingRowVerticalPadding
    var horizontalPadding: CGFloat? = nil

    var body: some View {
        TextField(placeholder, text: $text)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, verticalPadding)
            .padding(.horizontal, horizontalPadding ?? edgePadding)
            .accessibilityElement(children: .combine)
    }
}
