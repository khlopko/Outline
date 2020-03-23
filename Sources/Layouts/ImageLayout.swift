
import CoreGraphics

/// Abstraction of the image layout element.
public protocol ImageElement {

    /// Image model set to this element.
    var imageContent: ImageContent? { get }

}

/// Abstraction of the image model.
public protocol ImageContent {

    /// Size of the image.
    var size: CGSize { get }

}

/// Layout of the image element.
public struct ImageLayout : Layout {

    public typealias Child = Layout & ImageElement

    private var child: Child
    private let alignment: Alignment

    /// - Parameters:
    ///     - child: Element to be layouted.
    ///     - alignment: Alignment of the element in the parent. By default it is top left corner for the origin.
    public init(child: Child, alignment: Alignment = []) {
        self.child = child
        self.alignment = alignment
    }

    @discardableResult
    public mutating func layout(in rect: CGRect) -> CGRect {
        let size = calculateSize(in: rect)
        let origin = alignment.point(for: size, in: rect)
        let childRect = CGRect(origin: origin, size: size)
        return child.layout(in: childRect)
    }

    public func calculateSize(in rect: CGRect) -> CGSize {
        child.imageContent?.size ?? rect.size
    }

}
