
import CoreGraphics

@testable import Outline

class Element : Layout, CustomDebugStringConvertible {

    var debugDescription: String {
        var str = ""
        for _ in 0..<Int(rect.height / 2) {
            for _ in 0..<Int(rect.minX / 2) {
                str.append(" ")
            }
            for _ in 0..<Int(rect.width / 2) {
                str.append("+")
            }
            str.append("\n")
        }
        return str
    }

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
