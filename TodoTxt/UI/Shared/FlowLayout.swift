//
//  FlowLayout.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-10-15.
//

import SwiftUI

struct FlowLayout: SwiftUI.Layout {

    var spacing = Spacing.Semantic.elementGap

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(
                at: CGPoint(
                    x: bounds.minX + result.frames[index].minX,
                    y: bounds.minY + result.frames[index].minY),
                proposal: .unspecified
            )
        }
    }

    struct FlowResult {
        var frames: [CGRect] = []
        var size: CGSize = .zero

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)

                if currentX + size.width > maxWidth && currentX > 0 {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }

                frames.append(CGRect(origin: CGPoint(x: currentX, y: currentY), size: size))
                lineHeight = max(lineHeight, size.height)
                currentX += size.width + spacing
            }

            self.size = CGSize(width: maxWidth, height: currentY + lineHeight)
        }
    }

}

#Preview {
    FlowLayout(spacing: 8) {
        Text("+Work")
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(.blue.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 4))

        Text("@urgent")
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(.yellow.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 4))

        Text("@finance")
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(.yellow.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 4))

        Text("@meeting")
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(.yellow.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
    .padding()
    .frame(width: 250)
    .border(.gray)
}
