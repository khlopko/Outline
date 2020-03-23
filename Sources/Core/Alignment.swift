
import CoreGraphics

/// Represents options for the element alignment on the parent.
public struct Alignment : OptionSet {

    public typealias RawValue = Int

    /// Horizontal alignment to the leading (left) edge.
    public static let left = Alignment(0)

    /// Horizontal alignment to the trailing (right) edge.
    public static let right = Alignment(1)

    /// Horizontal alignment to the center in the parent.
    public static let horizontalCenter = Alignment(2)

    /// Vertical alignment to the top edge.
    public static let top = Alignment(3)

    /// Vertical alignment to the bottom edge.
    public static let bottom = Alignment(4)

    /// Vertical alignment to center in the parent.
    public static let verticalCenter = Alignment(5)

    public let rawValue: RawValue

    private init(_ value: Int) {
        self.init(rawValue: 1 << value)
    }

    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }

    /// - Parameters:
    ///     - size: Size of the view to be aligned.
    ///     - rect: Parent rectangle inside which the view should be aligned.
    ///
    /// - Returns: `CGPoint` instance with values calculated for current alignment options for passed size and parent rect.
    internal func point(for size: CGSize, in rect: CGRect) -> CGPoint {
        let x = calculateX(for: size, in: rect)
        let y = calculateY(for: size, in: rect)
        return CGPoint(x: x, y: y)
    }

    private func calculateX(for size: CGSize, in rect: CGRect) -> CGFloat {
        if contains(.horizontalCenter) {
            return rect.minX + (rect.width - size.width) * 0.5
        }
        if contains(.right) {
            return rect.maxX - size.width
        }
        return rect.minX
    }

    private func calculateY(for size: CGSize, in rect: CGRect) -> CGFloat {
        if contains(.verticalCenter) {
            return rect.minY + (rect.height - size.height) * 0.5
        }
        if contains(.bottom) {
            return rect.maxY - size.height
        }
        return rect.minY
    }

}
