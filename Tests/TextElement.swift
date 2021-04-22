
import UIKit

@testable import Outline

final class TextElement : Element, Outline.TextElement {

    struct Content: TextContent {

        let string: String

        func size(constrainedTo maxSize: CGSize, useDeviceMetrics: Bool) -> CGSize {
            let p = NSMutableParagraphStyle()
            p.lineBreakMode = .byWordWrapping
            let attributedString = NSAttributedString(
                string: string,
                attributes: [.font: UIFont.systemFont(ofSize: 14), .paragraphStyle: p])
            let calculatedSize =  attributedString.size(constrainedTo: maxSize, useDeviceMetrics: useDeviceMetrics)
            print(maxSize, calculatedSize, string, attributedString.size())
            return calculatedSize
        }

    }

    let textContent: TextContent?
    let elementContentInsets: Insets = .zero

    init(string: String) {
        textContent = Content(string: string)
    }

}
