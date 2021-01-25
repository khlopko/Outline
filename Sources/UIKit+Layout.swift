
#if canImport(UIKit)

import UIKit

extension UIView : Layout {

    @discardableResult
    public func layout(in rect: CGRect) -> CGRect {
        frame = rect
        return frame
    }

    public func calculateSize(in rect: CGRect) -> CGSize {
        .init(width: min(rect.width, frame.width), height: min(rect.height, frame.height))
    }

}

extension UILabel : TextElement {
    public var textContent: TextContent? { attributedText }
    public var elementContentInsets: Insets { .zero }
}

extension UITextView : TextElement {
    public var textContent: TextContent? { attributedText }
    public var elementContentInsets: Insets {
        .init(top: textContainerInset.top, left: textContainerInset.left, bottom: textContainerInset.bottom, right: textContainerInset.right)
    }
}

extension NSAttributedString : TextContent {

    public func size(constrainedTo maxSize: CGSize, useDeviceMetrics: Bool) -> CGSize {
        var options: NSStringDrawingOptions = [.usesLineFragmentOrigin]
        if useDeviceMetrics {
            options.insert(.usesDeviceMetrics)
        }
        let rect = boundingRect(with: maxSize, options: options, context: nil).integral
        let size = CGSize(width: ceil(rect.width), height: ceil(rect.height))
        return size
    }

}

extension UIImage : ImageContent {
}

extension UIImageView : ImageElement {
    public var imageContent: ImageContent? { image }
}

extension UIButton : ButtonElement {

    public var textContent: TextContent? {
        if let attributedString = attributedTitle(for: state) {
            return attributedString
        }
        if let string = title(for: state) {
            return NSAttributedString(string: string)
        }
        return nil
    }
    public var nestedImageElement: NestedImageElement? { imageView }
    public var elementContentInsets: ButtonElementInsets {
        .init(
            title: .init(
                top: titleEdgeInsets.top,
                left: titleEdgeInsets.left,
                bottom: titleEdgeInsets.bottom,
                right: titleEdgeInsets.right),
            image: .init(
                top: imageEdgeInsets.top,
                left: imageEdgeInsets.left,
                bottom: imageEdgeInsets.bottom,
                right: imageEdgeInsets.right))
    }

}

#endif
