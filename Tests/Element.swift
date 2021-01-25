
import CoreGraphics

@testable import Outline

class Element : Layout {

    private(set) var rect: CGRect = .zero

    func layout(in rect: CGRect) -> CGRect {
        self.rect = .init(origin: rect.origin, size: calculateSize(in: rect))
        return rect
    }

    func calculateSize(in rect: CGRect) -> CGSize { rect.size }

}

class SizedElement : Element {

    private let size: CGSize

    init(size: CGSize) {
        self.size = size
    }

    override func calculateSize(in rect: CGRect) -> CGSize { size }

}
