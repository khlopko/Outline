
import CoreGraphics

/// Size abstraction, which values depends on the axis.
public struct Size {

    /// The main axis of the size.
    public let axis: Axis

    /// `CGSize` representation of the size.
    public private(set) var cgSize: CGSize

    /// Value of the main axis.
    public var length: CGFloat {
        get {
            switch axis {
            case .x: return cgSize.width
            case .y: return cgSize.height
            }
        }
        set {
            switch axis {
            case .x: cgSize.width = newValue
            case .y: cgSize.height = newValue
            }
        }
    }

    /// Value of the orthogonal axis.
    public var crossLength: CGFloat {
        get {
            switch axis {
            case .x: return cgSize.height
            case .y: return cgSize.width
            }
        }
        set {
            switch axis {
            case .x: cgSize.height = newValue
            case .y: cgSize.width = newValue
            }
        }
    }

    /// Initializer which takes passed axis as the main axis and the size as it is.
    public init(axis: Axis, cgSize: CGSize) {
        self.axis = axis
        self.cgSize = cgSize
    }

    /// Initializer which takes passed `axis` as the main axis and creates `CGSize` element with the passed `length` and `crossLength`
    /// depending on the passed `axis`.
    ///
    /// If the `.x` axis passed, then `length` will be used as `width` and `crossLength`
    /// will be used as `height`; if the `.y` axis passed, then `length` will be used as `height` and `crossLength` as `width`.
    public init(axis: Axis, length: CGFloat, crossLength: CGFloat) {
        self.axis = axis
        switch axis {
        case .x: cgSize = CGSize(width: length, height: crossLength)
        case .y: cgSize = CGSize(width: crossLength, height: length)
        }
    }

}
