
import CoreGraphics

@testable import Outline

class Element : Layout {

    private(set) var rect: CGRect = .zero

    func layout(in rect: CGRect) -> CGRect {
        self.rect = rect
        return rect
    }

    func calculateSize(in rect: CGRect) -> CGSize { rect.size }

}
