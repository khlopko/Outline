
import CoreGraphics

/// Element layout abstraction.
public protocol Layout {

    /// Layouts element in the given rectangle.
    ///
    /// - Parameters:
    ///     - rect: Parent rectangle in which element should be layouted.
    ///
    /// - Returns: Final `CGRect` value, which was assigned to the element.
    @discardableResult
    mutating func layout(in rect: CGRect) -> CGRect

    /// Calculates the size that the element requires for layout.
    ///
    /// Use it in `layout(in:)` method if you implement custom `Layout`.
    ///
    /// - Parameters:
    ///     - rect: Parent rectangle in which element will be fit.
    ///
    /// - Returns: `CGSize` value which represents required size for this layout.
    func calculateSize(in rect: CGRect) -> CGSize

}
