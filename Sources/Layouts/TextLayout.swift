
import CoreGraphics

/// Abstraction of the text layout element.
public protocol TextElement {

    /// Text model set to to this element.
    var textContent: TextContent? { get }

    /// Text insets in this element.
    var elementContentInsets: Insets { get }

}

/// Abstraction of the text model.
public protocol TextContent {

    /// Returns the size of the text inside given container.
    ///
    /// - Parameters:
    ///     - maxSize: Container size for the text, limit values.
    ///     - useDeviceMetrics: Indicates whether or not to include `usesDeviceMetrics` option for size calculation.
    func size(constrainedTo maxSize: CGSize, useDeviceMetrics: Bool) -> CGSize

}

/// Layout of the text element.
public struct TextLayout : Layout {

    public typealias Child = Layout & TextElement

    private var child: Child
    private let alignment: Alignment
    private let options: SizeOption

    /// Options, that can be applied to the layout and would affect size calculation.
    public struct SizeOption : OptionSet {

        public typealias RawValue = Int

        /// Tells layout to pass  `useDeviceMetrics` in the text content calculation as `true`.
        public static let deviceMetrics = SizeOption(rawValue: 1)

        /// Tells layout to use parent width instead of the value, returned by the `TextContent` object.
        public static let parentWidth = SizeOption(rawValue: 2)

        public let rawValue: RawValue

        private init(_ value: RawValue) {
            rawValue = 1 << value
        }

        public init(rawValue: RawValue) {
            self.rawValue = rawValue
        }

    }

    /// - Parameters:
    ///     - child: Element to be layouted.
    ///     - alignment: Alignment of the element in the parent. By default it is top left corner for the origin.
    ///     - useDeviceMetrics: Indicates whether or not to include `usesDeviceMetrics` option for size calculation. Default is `false`.
    ///     - prefersParentWidth: Indicates wheter the parent width should be used or calculated text width. Default is `false`.
    public init(child: Child, alignment: Alignment = [], options: SizeOption = []) {
        self.child = child
        self.alignment = alignment
        self.options = options
    }

    @discardableResult
    public mutating func layout(in rect: CGRect) -> CGRect {
        let size = calculateSize(in: rect)
        let origin = alignment.point(for: size, in: rect)
        let childRect = CGRect(origin: origin, size: size)
        return child.layout(in: childRect)
    }

    public func calculateSize(in rect: CGRect) -> CGSize {
        let insets = child.elementContentInsets
        let constraintSize = rect.inset(by: insets).size
        var size = child.textContent?.size(
            constrainedTo: constraintSize,
            useDeviceMetrics: options.contains(.deviceMetrics)) ?? .zero
        size.height += insets.top + insets.bottom
        if options.contains(.parentWidth) {
            size.width = rect.width
        } else {
            size.width += insets.left + insets.right
        }
        return size
    }

}
