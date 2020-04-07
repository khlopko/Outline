
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

    func testInsetInsideComplexStack() {
        // g
        var vStack = StackLayout(axis: .y)
        var hStack = StackLayout(axis: .x)
        let side: CGFloat = 44
        let he1 = Element()
        hStack.append(SizeLayout(child: he1, side: side))
        let he2 = Element()
        let he2Height: CGFloat = 40
        let offset: CGFloat = 10
        hStack.append(SizeLayout(child: he2, height: he2Height, alignment: .bottom), offset: offset, flexible: .length)
        let he3 = Element()
        hStack.append(SizeLayout(child: he3, side: side), offset: offset)
        vStack.append(InsetLayout(child: hStack, dx: 22, dy: 0))
        let ve1 = Element()
        vStack.append(SizeLayout(child: ve1, height: 40), offset: 13)
        let parent = CGRect(x: 0, y: 17 - (side - he2Height), width: 375, height: 139)
        // w
        let rect = vStack.layout(in: parent)
        // t
        XCTAssertEqual(rect, CGRect(x: 0, y: 13, width: 375, height: 97))
        XCTAssertEqual(he1.rect, CGRect(x: 22, y: 13, width: side, height: side))
        XCTAssertEqual(he2.rect, CGRect(
            x: 22 + side + offset,
            y: parent.minY + (side - he2Height),
            width: parent.width - (22 + side + offset) * 2,
            height: 40))
        XCTAssertEqual(he3.rect, CGRect(x: parent.width - (22 + side), y: 13, width: side, height: side))
        XCTAssertEqual(ve1.rect, CGRect(x: 0, y: 13 + side + 13, width: 375, height: 40))
    }

}
