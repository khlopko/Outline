
import CoreGraphics

@testable import Outline

final class TextElement : Element, Outline.TextElement {

    struct Content: TextContent {

        let string: String

        func size(constrainedTo maxSize: CGSize, useDeviceMetrics: Bool) -> CGSize {
            CGSize(width: string.count, height: 21)
        }

    }

    let textContent: TextContent?
    let elementContentInsets: Insets = .zero

    init(string: String) {
        textContent = Content(string: string)
    }

}
