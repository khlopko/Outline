
import CoreGraphics

/// Allows to layout in the rect with the passed inset value.
public struct InsetLayout : Layout {

    public typealias Child = Layout

    private var child: Child
    private let insets: Insets

    public init(child: Child, insets: Insets) {
        self.child = child
        self.insets = insets
    }

    public init(child: Child, dx: CGFloat, dy: CGFloat) {
        self.child = child
        self.insets = Insets(top: dy, left: dx, bottom: dy, right: dx)
    }

    public mutating func layout(in rect: CGRect) -> CGRect {
        child.layout(in: rect.inset(by: insets))
    }

    public func calculateSize(in rect: CGRect) -> CGSize {
        child.calculateSize(in: rect.inset(by: insets))
    }

}
