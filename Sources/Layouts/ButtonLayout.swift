
import CoreGraphics

/// Abstraction for the button layout element.
public protocol ButtonElement {

    /// Text of the button for current state.
    var textContent: TextContent? { get }

    /// Image element type.
    typealias NestedImageElement = Layout & ImageElement

    /// Image element of the button.
    var nestedImageElement: NestedImageElement? { get }

    /// Content insets set to the button.
    var elementContentInsets: ButtonElementInsets { get }

}

/// Button element insets.
public struct ButtonElementInsets {
    let title: Insets
    let image: Insets
}

/// Layout for the button element.
public struct ButtonLayout : Layout {

    /// Size calculation options.
    public enum SizeOption {

        /// Layout will use height of the parent rect.
        case parentHeight

        /// Layout will use custom provided height.
        case customHeight(CGFloat)

    }

    public typealias Child = Layout & ButtonElement

    private var child: Child
    private let imageSize: CGSize?
    private let insets: Insets
    private let option: SizeOption?
    private let alignment: Alignment

    /// Initializer for the button with the square image.
    ///
    /// - Parameters:
    ///     - child: Element to be layouted.
    ///     - imageSide: Length of the side (both width & height) of the image.
    ///     - alignment: Alignment of the element in the parent. By default it is top left corner for the origin.
    public init(child: Child, imageSide: CGFloat, alignment: Alignment = []) {
        self.init(child: child, imageSize: CGSize(width: imageSide, height: imageSide), alignment: alignment)
    }

    /// Initializer for the button with the given image size, insets and sizing option.
    ///
    /// - Parameters:
    ///     - child: Element to be layouted.
    ///     - imageSize: Size of the element. Can be `nil`. Default is `nil`.
    ///     - insets: Insets for the button around image. Default is `.zero`.
    ///     - option: Sizing option for the button, used in size calculation.
    ///     - alignment: Alignment of the element in the parent. By default it is top left corner for the origin.
    public init(
        child: Child,
        imageSize: CGSize? = nil,
        insets: Insets = .zero,
        option: SizeOption? = nil,
        alignment: Alignment = []
    ) {
        self.child = child
        self.imageSize = imageSize
        self.insets = insets
        self.option = option
        self.alignment = alignment
    }

    @discardableResult
    public mutating func layout(in rect: CGRect) -> CGRect {
        let size = calculateSize(in: rect)
        let origin = alignment.point(for: size, in: rect)
        let resultRect = child.layout(in: CGRect(origin: origin, size: size))
        return resultRect
    }

    public func calculateSize(in rect: CGRect) -> CGSize {
        var titleSize: CGSize = .zero
        if let storage = child.textContent {
            titleSize = storage.size(constrainedTo: rect.size, useDeviceMetrics: false)
        }
        let imageSize = finalImageSize
        let contentInsets = child.elementContentInsets
        let width = calculateWidth(in: rect, contentInsets: contentInsets, imageSize: imageSize, titleSize: titleSize)
        let height = calculateHeight(in: rect, contentInsets: contentInsets, imageSize: imageSize, titleSize: titleSize)
        return CGSize(width: width, height: height)
    }

    private var finalImageSize: CGSize {
        if let specifiedImageSize = imageSize {
            return specifiedImageSize
        } else if let storage = child.nestedImageElement?.imageContent {
            return storage.size
        }
        return .zero
    }

    private func calculateWidth(
        in rect: CGRect,
        contentInsets: ButtonElementInsets,
        imageSize: CGSize,
        titleSize: CGSize
    ) -> CGFloat {
        insets.left
        + contentInsets.image.left + imageSize.width + contentInsets.image.right
        + contentInsets.title.left + titleSize.width + contentInsets.title.right
        + insets.right
    }

    private func calculateHeight(
        in rect: CGRect,
        contentInsets: ButtonElementInsets,
        imageSize: CGSize,
        titleSize: CGSize
    ) -> CGFloat {
        if let option = option {
            switch option {
            case .parentHeight: return rect.height
            case let .customHeight(height): return height
            }
        }
        return insets.top
            + max(contentInsets.image.top, contentInsets.title.top)
            + max(imageSize.height, titleSize.height)
            + max(contentInsets.image.bottom, contentInsets.title.bottom)
            + insets.bottom
    }

}

