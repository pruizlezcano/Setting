//
//  SettingPicker.swift
//  Setting
//
//  Created by A. Zheng (github.com/aheze) on 2/21/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import SwiftUI

// MARK: - SettingPicker

/**
 A multi-choice picker with SwiftUI Picker-style API.
 Supports custom views, enum bindings, and all display modes.
 */
public struct SettingPicker<SelectionValue: Hashable, Content: View>: View, Setting {
    public var id: AnyHashable?
    public var icon: SettingIcon?
    public var title: String

    @Binding var selection: SelectionValue
    let content: () -> Content

    public var foregroundColor: Color?
    public var horizontalSpacing = CGFloat(12)
    public var verticalPadding = CGFloat.settingRowVerticalPadding
    public var horizontalPadding: CGFloat?
    public var choicesConfiguration = ChoicesConfiguration()

    public init(
        _ title: String = "",
        id: AnyHashable? = nil,
        icon: SettingIcon? = nil,
        selection: Binding<SelectionValue>,
        foregroundColor: Color? = nil,
        horizontalSpacing: CGFloat = CGFloat(12),
        verticalPadding: CGFloat = CGFloat.settingRowVerticalPadding,
        horizontalPadding: CGFloat? = nil,
        choicesConfiguration: ChoicesConfiguration = ChoicesConfiguration(),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.id = id
        self.icon = icon
        self.title = title
        _selection = selection
        self.content = content
        self.foregroundColor = foregroundColor
        self.horizontalSpacing = horizontalSpacing
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
        self.choicesConfiguration = choicesConfiguration
    }

    public enum PickerDisplayMode {
        case navigation
        case menu
        case inline
    }

    public struct ChoicesConfiguration {
        public var verticalPadding = CGFloat.settingRowVerticalPadding
        public var horizontalPadding: CGFloat?
        public var pageNavigationTitleDisplayMode = SettingPage.NavigationTitleDisplayMode.inline
        public var pickerDisplayMode = PickerDisplayMode.navigation
        public var groupHeader: String?
        public var groupFooter: String?
        public var groupHorizontalPadding: CGFloat?
        public var groupBackgroundColor: Color?
        public var groupBackgroundCornerRadius = CGFloat(12)
        public var groupDividerLeadingMargin = CGFloat(16)
        public var groupDividerTrailingMargin = CGFloat(0)
        public var groupDividerColor: Color?

        public init(
            verticalPadding: CGFloat = CGFloat.settingRowVerticalPadding,
            horizontalPadding: CGFloat? = nil,
            pageNavigationTitleDisplayMode: SettingPage.NavigationTitleDisplayMode = SettingPage.NavigationTitleDisplayMode.inline,
            pickerDisplayMode: PickerDisplayMode = PickerDisplayMode.navigation,
            groupHeader: String? = nil,
            groupFooter: String? = nil,
            groupHorizontalPadding: CGFloat? = nil,
            groupBackgroundColor: Color? = nil,
            groupBackgroundCornerRadius: CGFloat = CGFloat(12),
            groupDividerLeadingMargin: CGFloat = CGFloat(16),
            groupDividerTrailingMargin: CGFloat = CGFloat(0),
            groupDividerColor: Color? = nil
        ) {
            self.verticalPadding = verticalPadding
            self.horizontalPadding = horizontalPadding
            self.pageNavigationTitleDisplayMode = pageNavigationTitleDisplayMode
            self.pickerDisplayMode = pickerDisplayMode
            self.groupHeader = groupHeader
            self.groupFooter = groupFooter
            self.groupHorizontalPadding = groupHorizontalPadding
            self.groupBackgroundColor = groupBackgroundColor
            self.groupBackgroundCornerRadius = groupBackgroundCornerRadius
            self.groupDividerLeadingMargin = groupDividerLeadingMargin
            self.groupDividerTrailingMargin = groupDividerTrailingMargin
            self.groupDividerColor = groupDividerColor
        }
    }

    public var body: some View {
        SettingPickerView(
            icon: icon,
            title: title,
            selection: $selection,
            content: content,
            foregroundColor: foregroundColor,
            horizontalSpacing: horizontalSpacing,
            verticalPadding: verticalPadding,
            horizontalPadding: horizontalPadding,
            choicesConfiguration: choicesConfiguration
        )
        .id(identifier)
        .highlightIfTargeted(id: identifier)
    }
}

/// Convenience modifiers.
public extension SettingPicker {
    func pickerDisplayMode(_ pickerDisplayMode: PickerDisplayMode) -> SettingPicker {
        var picker = self
        picker.choicesConfiguration.pickerDisplayMode = pickerDisplayMode
        return picker
    }
}

// MARK: - SettingPickerView

struct SettingPickerView<SelectionValue: Hashable, Content: View>: View {
    @Environment(\.edgePadding) var edgePadding
    @Environment(\.settingSecondaryColor) var settingSecondaryColor

    var icon: SettingIcon?
    let title: String
    @Binding var selection: SelectionValue
    let content: () -> Content

    var foregroundColor: Color?
    var horizontalSpacing = CGFloat(12)
    var verticalPadding = CGFloat.settingRowVerticalPadding
    var horizontalPadding: CGFloat? = nil
    var choicesConfiguration: SettingPicker<SelectionValue, Content>.ChoicesConfiguration

    @State var isActive = false

    var body: some View {
        switch choicesConfiguration.pickerDisplayMode {
        case .navigation:
            navigationModePicker
        case .menu:
            menuModePicker
        case .inline:
            inlineModePicker
        }
    }

    var navigationModePicker: some View {
        Button {
            isActive = true
        } label: {
            HStack(spacing: horizontalSpacing) {
                if let icon {
                    SettingIconView(icon: icon)
                }

                Text(title)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, verticalPadding)

                // Show selected view content
                content()
                    .environment(\.pickerSelectionMode, .preview)
                    .environment(\.pickerSelectedValue, AnyHashable(selection))
                    .foregroundColor(foregroundColor ?? settingSecondaryColor)

                Image(systemName: "chevron.forward")
                    .foregroundColor(foregroundColor ?? settingSecondaryColor)
            }
            .padding(.horizontal, horizontalPadding ?? edgePadding)
            .accessibilityElement(children: .combine)
        }
        .buttonStyle(.row)
        .background {
            NavigationLink(isActive: $isActive) {
                SettingPickerChoicesView(
                    title: title,
                    selection: $selection,
                    content: content,
                    choicesConfiguration: choicesConfiguration
                )
            } label: {
                EmptyView()
            }
            .opacity(0)
        }
    }

    var menuModePicker: some View {
        HStack(spacing: horizontalSpacing) {
            if let icon {
                SettingIconView(icon: icon)
            }

            Text(title)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, verticalPadding)

            Picker("", selection: $selection) {
                content()
            }
            .pickerStyle(.menu)
            #if os(iOS)
                .padding(.trailing, -edgePadding + 2)
            #else
                .padding(.trailing, -2)
            #endif
                .tint(foregroundColor ?? settingSecondaryColor)
        }
        .padding(.horizontal, horizontalPadding ?? edgePadding)
        .accessibilityElement(children: .combine)
    }

    var inlineModePicker: some View {
        let erasedSelection = Binding<AnyHashable>(
            get: { AnyHashable(selection) },
            set: { newValue in
                if let typedValue = newValue.base as? SelectionValue {
                    selection = typedValue
                }
            }
        )

        return content()
            .environment(\.pickerSelectionMode, .inline)
            .environment(\.pickerSelection, erasedSelection)
            .environment(\.pickerVerticalPadding, choicesConfiguration.verticalPadding)
            .environment(\.pickerHorizontalPadding, choicesConfiguration.horizontalPadding)
    }
}

// MARK: - SettingPickerChoicesView

struct SettingPickerChoicesView<SelectionValue: Hashable, Content: View>: View {
    let title: String
    @Binding var selection: SelectionValue
    let content: () -> Content
    var choicesConfiguration: SettingPicker<SelectionValue, Content>.ChoicesConfiguration

    var body: some View {
        SettingPageView(title: title, navigationTitleDisplayMode: choicesConfiguration.pageNavigationTitleDisplayMode) {
            let erasedSelection = Binding<AnyHashable>(
                get: { AnyHashable(selection) },
                set: { newValue in
                    if let typedValue = newValue.base as? SelectionValue {
                        selection = typedValue
                    }
                }
            )

            let settingGroupView = SettingGroupView(
                header: choicesConfiguration.groupHeader,
                footer: choicesConfiguration.groupFooter,
                horizontalPadding: choicesConfiguration.groupHorizontalPadding,
                backgroundColor: choicesConfiguration.groupBackgroundColor,
                backgroundCornerRadius: choicesConfiguration.groupBackgroundCornerRadius,
                dividerLeadingMargin: choicesConfiguration.groupDividerLeadingMargin,
                dividerTrailingMargin: choicesConfiguration.groupDividerTrailingMargin,
                dividerColor: choicesConfiguration.groupDividerColor
            ) {
                content()
                    .environment(\.pickerSelectionMode, .selection)
                    .environment(\.pickerSelection, erasedSelection)
                    .environment(\.pickerVerticalPadding, choicesConfiguration.verticalPadding)
                    .environment(\.pickerHorizontalPadding, choicesConfiguration.horizontalPadding)
            }
            settingGroupView
        }
    }
}

// MARK: - Environment Keys for Picker Context

private struct PickerSelectionModeKey: EnvironmentKey {
    static let defaultValue: PickerSelectionDisplayMode = .selection
}

private struct PickerSelectionKey: EnvironmentKey {
    static let defaultValue: Binding<AnyHashable>? = nil
}

private struct PickerSelectedValueKey: EnvironmentKey {
    static let defaultValue: AnyHashable? = nil
}

private struct PickerVerticalPaddingKey: EnvironmentKey {
    static let defaultValue: CGFloat = 14
}

private struct PickerHorizontalPaddingKey: EnvironmentKey {
    static let defaultValue: CGFloat? = nil
}

enum PickerSelectionDisplayMode {
    case selection // Full selection page
    case preview // Preview in main row
    case inline // Inline display
}

extension EnvironmentValues {
    var pickerSelectionMode: PickerSelectionDisplayMode {
        get { self[PickerSelectionModeKey.self] }
        set { self[PickerSelectionModeKey.self] = newValue }
    }

    var pickerSelection: Binding<AnyHashable>? {
        get { self[PickerSelectionKey.self] }
        set { self[PickerSelectionKey.self] = newValue }
    }

    var pickerSelectedValue: AnyHashable? {
        get { self[PickerSelectedValueKey.self] }
        set { self[PickerSelectedValueKey.self] = newValue }
    }

    var pickerVerticalPadding: CGFloat {
        get { self[PickerVerticalPaddingKey.self] }
        set { self[PickerVerticalPaddingKey.self] = newValue }
    }

    var pickerHorizontalPadding: CGFloat? {
        get { self[PickerHorizontalPaddingKey.self] }
        set { self[PickerHorizontalPaddingKey.self] = newValue }
    }
}

// MARK: - View Extensions for Picker Integration

public extension View {
    /// Makes a view selectable in a SettingPicker with proper layout and selection indicator
    func settingPickerOption<V: Hashable>(_ tag: V) -> some View {
        modifier(SettingPickerOptionModifier(tag: tag))
    }
}

private struct SettingPickerOptionModifier<Tag: Hashable>: ViewModifier {
    let tag: Tag
    @Environment(\.pickerSelectionMode) var mode
    @Environment(\.pickerSelection) var selection
    @Environment(\.pickerSelectedValue) var selectedValue
    @Environment(\.pickerVerticalPadding) var verticalPadding
    @Environment(\.pickerHorizontalPadding) var horizontalPadding

    func body(content: Content) -> some View {
        switch mode {
        case .preview:
            // Show only if this is the selected option
            if let selectedValue = selectedValue, AnyHashable(tag) == selectedValue {
                content
            }

        case .selection, .inline:
            Button {
                if let binding = selection {
                    binding.wrappedValue = AnyHashable(tag)
                }
            } label: {
                HStack {
                    content
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, verticalPadding)

                    if let selectedValue = selectedValue ?? selection?.wrappedValue {
                        if AnyHashable(tag) == selectedValue {
                            Image(systemName: "checkmark")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
                .padding(.horizontal, horizontalPadding)
            }
            .buttonStyle(.row)
            .tag(tag)
        }
    }
}
