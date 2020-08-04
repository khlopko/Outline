
import CoreGraphics

/// Allows to layout child elements in the same place.
public struct ZLayout: Layout {

    public typealias Child = Layout

    private var children: [Child]

    public init(children: [Child]) {
        self.children = children
    }

    @discardableResult
    public mutating func layout(in rect: CGRect) -> CGRect {
        for index in children.indices {
            children[index].layout(in: rect)
        }
        return rect
    }

    public func calculateSize(in rect: CGRect) -> CGSize {
        rect.size
    }

}
