
import CoreGraphics

/// Point abstraction, which values depends on the axis.
public struct Point {

    /// The main axis of the point.
    public let axis: Axis

    /// `CGPoint` representation of the size.
    public private(set) var cgPoint: CGPoint

    /// Value of the main axis.
    public var offset: CGFloat {
        get {
            switch axis {
            case .x: return cgPoint.x
            case .y: return cgPoint.y
            }
        }
        set {
            switch axis {
            case .x: cgPoint.x = newValue
            case .y: cgPoint.y = newValue
            }
        }
    }

    /// Value of the orthogonal axis.
    public var crossOffset: CGFloat {
        get {
            switch axis {
            case .x: return cgPoint.y
            case .y: return cgPoint.x
            }
        }
        set {
            switch axis {
            case .x: cgPoint.y = newValue
            case .y: cgPoint.x = newValue
            }
        }
    }

    /// Initializer which takes passed axis as the main axis and the point as it is.
    public init(axis: Axis, cgPoint: CGPoint) {
        self.axis = axis
        self.cgPoint = cgPoint
    }

    /// Initializer which takes passed `axis` as the main axis and creates `CGPoint` element with the passed `length` and `crossLength`
    /// depending on the passed `axis`.
    ///
    /// If the `.x` axis passed, then `length` will be used as `x` and `crossLength` will be used as `y`;
    /// if the `.y` axis passed, then `length` will be used as `y` and `crossLength` as `x`.
    public init(axis: Axis, offset: CGFloat, crossOffset: CGFloat) {
        self.axis = axis
        switch axis {
        case .x: cgPoint = CGPoint(x: offset, y: crossOffset)
        case .y: cgPoint = CGPoint(x: crossOffset, y: offset)
        }
    }

}
