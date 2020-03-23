
import XCTest

@testable import Outline

final class ZLayoutTests : XCTestCase {

    func testComplexCardLayout() {
        // g
        let d: CGFloat = 5
        let e1 = Element()
        let e2 = Element()
        let e3 = Element()
        var layout = ZLayout(children: [
            InsetLayout(child: e1, dx: d, dy: d),
            InsetLayout(child: e2, dx: d, dy: d),
            SizeLayout(child: e3)
        ])
        let parent = CGRect(x: 0, y: 0, width: 64, height: 64)
        // w
        let rect = layout.layout(in: parent)
        // t
        XCTAssertEqual(rect, parent)
        XCTAssertEqual(e1.rect, parent.insetBy(dx: d, dy: d))
        XCTAssertEqual(e2.rect, parent.insetBy(dx: d, dy: d))
        XCTAssertEqual(e3.rect, parent)
    }

}
