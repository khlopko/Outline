
import XCTest

@testable import Outline

final class InsetLayoutTests : XCTestCase {

    func testSimpleInsetLayout() {
        // g
        let d: CGFloat = 5
        let e1 = Element()
        var layout = InsetLayout(child: SizeLayout(child: e1, option: .squareByWidth), dx: d, dy: d)
        let length: CGFloat = 44
        let parent = CGRect(x: 0, y: 0, width: length, height: 64)
        // w
        let rect = layout.layout(in: parent)
        // t
        let es = length - d * 2
        XCTAssertEqual(rect, CGRect(x: d, y: d, width: es, height: es))
    }

}
