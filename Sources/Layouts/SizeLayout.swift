
import CoreGraphics

/// Layouts element with the given size.
public struct SizeLayout : Layout {

    public typealias Child = Layout

    private var child: Child
    private let width: CGFloat?
    private let height: CGFloat?
    private let option: SizeOption?
    private let alignment: Alignment

    /// Size calculation options.
    public enum SizeOption {

        /// Layout will use size, returned by the `child`, rather than parent.
        case useChildSize

        /// Size, used to layout the `child` will be squared, using parent `width` value.
        case squareByWidth

        /// Size, used to layout the `child` will be squared, using parent `height` value.
        case squareByHeight

    }

    /// Initializer with `side` parameter for square layouts.
    ///
    /// - Parameters:
    ///     - child: Element to be layouted.
    ///     - side: Length of the side (both width & height) of the element.
    ///     - alignment: Alignment of the element in the parent. By default it is top left corner for the origin.
    public init(child: Child, side: CGFloat, alignment: Alignment = []) {
        self.init(child: child, width: side, height: side, alignment: alignment)
    }

    /// Initializer with `cgSize: CGSize` parameter for layouts with predefined size value.
    ///
    /// - Parameters:
    ///     - child: Element to be layouted.
    ///     - cgSize: Size of the element.
    ///     - alignment: Alignment of the element in the parent. By default it is top left corner for the origin.
    public init(child: Child, cgSize: CGSize, alignment: Alignment = []) {
        self.init(child: child, width: cgSize.width, height: cgSize.height, alignment: alignment)
    }

    /// Initializer with `size: Size` parameter for layout with predefined size value, which depends on the layout axis.
    ///
    /// - Parameters:
    ///     - child: Element to be layouted.
    ///     - size: Axis-dependent size of the element.
    ///     - alignment: Alignment of the element in the parent. By default it is top left corner for the origin.
    public init(child: Child, size: Size, alignment: Alignment = []) {
        let size = size.cgSize
        let width: CGFloat? = size.width.isZero ? nil : size.width
        let height: CGFloat? = size.height.isZero ? nil : size.height
        self.init(child: child, widthOrNil: width, heightOrNil: height, option: nil, alignment: alignment)
    }

    /// - Parameters:
    ///     - child: Element to be layouted.
    ///     - alignment: Alignment of the element in the parent. By default it is top left corner for the origin.
    public init(child: Child, alignment: Alignment = []) {
        self.init(child: child, widthOrNil: nil, heightOrNil: nil, option: nil, alignment: alignment)
    }

    /// - Parameters:
    ///     - child: Element to be layouted.
    ///     - option: Defines option for the size calculation during layout.
    ///     - alignment: Alignment of the element in the parent. By default it is top left corner for the origin.
    public init(child: Child, option: SizeOption, alignment: Alignment = []) {
        self.init(child: child, widthOrNil: nil, heightOrNil: nil, option: option, alignment: alignment)
    }

    /// Initializer with `width` and `height` parameters for layouts with predefined width and/or height.
    ///
    /// - Parameters:
    ///     - child: Element to be layouted.
    ///     - width: Width of the element.
    ///     - alignment: Alignment of the element in the parent. By default it is top left corner for the origin.
    public init(child: Child, width: CGFloat?, alignment: Alignment = []) {
        self.init(child: child, widthOrNil: width, heightOrNil: nil, option: nil, alignment: alignment)
    }

    /// Initializer with `width` and `height` parameters for layouts with predefined width and/or height.
    ///
    /// - Parameters:
    ///     - child: Element to be layouted.
    ///     - height: Height of the element.
    ///     - alignment: Alignment of the element in the parent. By default it is top left corner for the origin.
    public init(child: Child, height: CGFloat?, alignment: Alignment = []) {
        self.init(child: child, widthOrNil: nil, heightOrNil: height, option: nil, alignment: alignment)
    }

    /// Initializer with `width` and `height` parameters for layouts with predefined width and/or height.
    ///
    /// - Parameters:
    ///     - child: Element to be layouted.
    ///     - width: Width of the element.
    ///     - height: Height of the element.
    ///     - alignment: Alignment of the element in the parent. By default it is top left corner for the origin.
    public init(child: Child, width: CGFloat, height: CGFloat, alignment: Alignment = []) {
        self.init(child: child, widthOrNil: width, heightOrNil: height, option: nil, alignment: alignment)
    }

    private init(child: Child, widthOrNil: CGFloat?, heightOrNil: CGFloat?, option: SizeOption?, alignment: Alignment) {
        self.child = child
        self.width = widthOrNil
        self.height = heightOrNil
        self.option = option
        self.alignment = alignment
    }

    @discardableResult
    public mutating func layout(in rect: CGRect) -> CGRect {
        let size = calculateSize(in: rect)
        let origin = alignment.point(for: size, in: rect)
        return child.layout(in: CGRect(origin: origin, size: size))
    }

    public func calculateSize(in rect: CGRect) -> CGSize {
        guard let option = option else {
            let width = self.width ?? rect.width
            let height = self.height ?? rect.height
            return CGSize(width: width, height: height)
        }
        switch option {
        case .useChildSize:
            return child.calculateSize(in: rect)
        case .squareByWidth:
            return CGSize(width: rect.width, height: rect.width)
        case .squareByHeight:
            return CGSize(width: rect.height, height: rect.height)
        }
    }

}
