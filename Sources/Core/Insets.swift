
import CoreGraphics

/// Insets abstraction for the layout.
public struct Insets {

    /// Insets with the all values set to zero.
    public static let zero = Insets()

    /// Inset from the top y point.
    public let top: CGFloat

    /// Inset from the left x point.
    public let left: CGFloat

    /// Inset from the bottom y point.
    public let bottom: CGFloat

    /// Inset from the right x point.
    public let right: CGFloat

    public init(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
        self.top = top
        self.left = left
        self.bottom = bottom
        self.right = right
    }

    public init(equal: CGFloat = 0) {
        top = equal
        left = equal
        bottom = equal
        right = equal
    }

}

extension CGRect {

    internal func inset(by insets: Insets) -> CGRect {
        CGRect(
            x: origin.x + insets.left,
            y: origin.y + insets.top,
            width: width - insets.left - insets.right,
            height: height - insets.top - insets.bottom)
    }

}
