
import CoreGraphics

internal protocol AdjustmentElement {
    var point: Point { get }
    var flexible: Flexible { get }
}

/// Allows to provide custom measurement convertation if needed, e.g. to scale offsets depending on the screen size.
public protocol ConvertOffset {

    init(axis: Axis)

    /// Preforms convertation of the given value.
    ///
    /// - Parameters:
    ///     - value: Original offset value.
    ///
    /// - Returns: Converted measurement.
    func converted(_ value: CGFloat) -> CGFloat

}

/// Defines which measurements can be flexible.
public struct Flexible : OptionSet {

    public typealias RawValue = Int

    /// Sets length to be flexible value.
    public static let length = Flexible(rawValue: 1)

    public let rawValue: RawValue

    private init(_ value: RawValue) {
        rawValue = 1 << value
    }

    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }

}

/// Allows to layout in vertical and horizonal stack.
public struct StackLayout : Layout {

    /// Child element of the layout.
    public typealias Child = Layout

    /// If not nil, it will be used for the all elements offsets during layout.
    public var convertOffset: ConvertOffset?

    private let axis: Axis

    private typealias Element = LayoutElement
    private var elements: [Element] = []

    public init(axis: Axis) {
        self.axis = axis
    }

    public init(axis: Axis, @StackLayoutBuilder make: () -> [(_ axis: Axis) -> StackLayout.LayoutElement]) {
        self.axis = axis
        elements = make().map { $0(axis) }
    }

    /// Add to the end of stack new element.
    ///
    /// - Parameters:
    ///     - child: Element to be layouted.
    ///     - offset: Offset from the previous element in the stack by the main axis. Default is `0`.
    ///     - crossOffset: Offset from the origin by the orthogonal axis. Default is `0`.
    ///     - flexible: Set of the flexability options. Default is empty.
    public mutating func append(
        _ child: Child,
        offset: CGFloat = 0,
        crossOffset: CGFloat = 0,
        flexible: Flexible = []
    ) {
        let point = Point(axis: axis, offset: offset, crossOffset: crossOffset)
        elements.append(Element(child: child, point: point, flexible: flexible))
    }

    /// Add to the end of stack new element.
    ///
    /// - Parameters:
    ///     - child: Element to be layouted.
    ///     - length: Length of the element.
    ///     - offset: Offset from the previous element in the stack by the main axis. Default is `0`.
    ///     - crossOffset: Offset from the origin by the orthogonal axis. Default is `0`.
    ///     - flexible: Set of the flexability options. Default is empty.
    public mutating func append(
        _ child: Child,
        length: CGFloat,
        offset: CGFloat = 0,
        crossOffset: CGFloat = 0,
        flexible: Flexible = []
    ) {
        let child = SizeLayout(child: child, size: Size(axis: axis, length: length, crossLength: 0))
        let point = Point(axis: axis, offset: offset, crossOffset: crossOffset)
        elements.append(Element(child: child, point: point, flexible: flexible))
    }

    @discardableResult
    public mutating func layout(in rect: CGRect) -> CGRect {
        let layoutedSize = layoutElements(in: rect)
        return CGRect(origin: rect.origin, size: layoutedSize.cgSize)
    }

    private typealias Measurement = (point: Point, size: Size)

    private mutating func layoutElements(in rect: CGRect) -> Size {
        let measurements = allMeasurements(rect: rect)
        let origin = Point(axis: axis, cgPoint: rect.origin)
        var current = origin
        var layoutedSizes: [Size] = []
        let size = Size(axis: axis, cgSize: rect.size)
        for (index, measurement) in measurements.enumerated() {
            current.offset += measurement.point.offset
            current.crossOffset = origin.crossOffset + measurement.point.crossOffset
            let containerSize = Size(axis: axis, length: measurement.size.length, crossLength: size.crossLength)
            let elementRect = elements[index].layout(in: CGRect(origin: current.cgPoint, size: containerSize.cgSize))
            let elementSize = Size(axis: axis, cgSize: elementRect.size)
            current.offset += elementSize.length
            layoutedSizes.append(elementSize)
        }
        return Size(
            axis: axis,
            length: current.offset - origin.offset,
            crossLength: layoutedSizes.max { $0.crossLength < $1.crossLength }?.crossLength ?? size.crossLength)
    }

    public func calculateSize(in rect: CGRect) -> CGSize {
        let measurements = allMeasurements(rect: rect)
        let size = Size(axis: axis, cgSize: rect.size)
        let resultSize = Size(
            axis: axis,
            length: measurements.reduce(0, { $0 + $1.point.offset + $1.size.length }),
            crossLength: measurements.max { $0.size.crossLength < $1.size.crossLength }?.size.crossLength ?? size.crossLength)
        return resultSize.cgSize
    }

    private func allMeasurements(rect: CGRect) -> [Measurement] {
        let size = Size(axis: axis, cgSize: rect.size)
        let staticMeasurements = self.staticMeasurements(in: rect)
        let staticLength = staticMeasurements.reduce(0, { $0 + $1.point.offset + $1.size.length })
        let flexOffsets = self.flexOffsets()
        let flexLength = size.length - staticLength - flexOffsets.reduce(0, { $0 + $1.point.offset })
        let flexElementLength = flexLength / CGFloat(flexOffsets.count)
        var measurements = staticMeasurements
        for flexOffset in flexOffsets {
            let estimatedElementSize = Size(axis: axis, cgSize: elements[flexOffset.index].calculateSize(in: rect))
            let elementSize = Size(axis: axis, length: flexElementLength, crossLength: estimatedElementSize.crossLength)
            measurements.insert(Measurement(flexOffset.point, elementSize), at: flexOffset.index)
        }
        return measurements
    }

    private func staticMeasurements(in rect: CGRect) -> [Measurement] {
        let convert = convertOffset?.converted ?? { $0 }
        return elements
            .filter { !$0.flexible.contains(.length) }
            .map { element -> Measurement in
                Measurement(
                    Point(point: element.point, convert: convert),
                    Size(axis: axis, cgSize: element.calculateSize(in: rect)))
            }
    }

    private typealias FlexOffset = (index: Int, point: Point)

    private func flexOffsets() -> [FlexOffset] {
        let convert = convertOffset?.converted ?? { $0 }
        return elements
            .enumerated()
            .compactMap { (index, element) -> FlexOffset? in
                element.flexible.contains(.length)
                    ? FlexOffset(index, Point(point: element.point, convert: convert))
                    : nil
            }
    }

}

// MARK: - LayoutElement

extension StackLayout {

    public struct LayoutElement : Layout, AdjustmentElement {

        private var child: Child
        internal let point: Point
        internal let flexible: Flexible

        internal init(child: Child, point: Point, flexible: Flexible) {
            self.child = child
            self.point = point
            self.flexible = flexible
        }

        @discardableResult
        public mutating func layout(in rect: CGRect) -> CGRect {
            child.layout(in: rect)
        }

        public func calculateSize(in rect: CGRect) -> CGSize {
            child.calculateSize(in: rect)
        }

    }

}

extension Point {

    fileprivate init(point: Point, convert: (CGFloat) -> CGFloat) {
        self.init(axis: point.axis, offset: convert(point.offset), crossOffset: convert(point.crossOffset))
    }

}
