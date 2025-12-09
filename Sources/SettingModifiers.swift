//
//  SettingModifiers.swift
//  Setting
//
//  Created by A. Zheng (github.com/aheze) on 5/8/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import SwiftUI

extension View {
    func horizontalEdgePadding() -> some View {
        modifier(EdgePaddingModifier(edges: .horizontal))
    }

    /// Applies a highlight animation to the view if it matches the scroll target ID
    func highlightIfTargeted(id: AnyHashable) -> some View {
        modifier(HighlightIfTargetedModifier(settingID: id))
    }
}

struct EdgePaddingModifier: ViewModifier {
    var edges: Edge.Set

    @Environment(\.edgePadding) var edgePadding

    func body(content: Content) -> some View {
        content
            .padding(edges, edgePadding)
    }
}

struct HighlightIfTargetedModifier: ViewModifier {
    let settingID: AnyHashable

    @Environment(\.scrollTargetID) var scrollTargetID
    @State private var isHighlighted = false

    func body(content: Content) -> some View {
        content
            .background(
                Rectangle()
                    .fill(Color.accentColor.opacity(isHighlighted ? 0.15 : 0))
                    .animation(.easeInOut(duration: 0.3), value: isHighlighted)
            )
            .onAppear {
                if scrollTargetID == settingID {
                    // Small delay to let the view appear, then highlight
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isHighlighted = true

                        // Remove highlight after a moment
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            isHighlighted = false
                        }
                    }
                }
            }
    }
}
