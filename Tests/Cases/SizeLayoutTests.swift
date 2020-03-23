
import XCTest

@testable import Outline

final class SizeLayoutTests : XCTestCase {

    func testSquareByWidth() {
        // g
        let e1 = Element()
        var layout = SizeLayout(child: e1, option: .squareByWidth)
        let parent = CGRect(x: 0, y: 0, width: 375, height: 812)
        // w
        let rect = layout.layout(in: parent)
        // t
        XCTAssertEqual(rect, CGRect(x: 0, y: 0, width: parent.width, height: parent.width))
    }

    func testSquareByHeight() {
        // g
        let e1 = Element()
        var layout = SizeLayout(child: e1, option: .squareByHeight)
        let parent = CGRect(x: 0, y: 0, width: 375, height: 64)
        // w
        let rect = layout.layout(in: parent)
        // t
        XCTAssertEqual(rect, CGRect(x: 0, y: 0, width: parent.height, height: parent.height))
    }

    func testUseChildSize() {
        // g
        let offset: CGFloat = 10
        var stack = StackLayout(axis: .y)
        let title = TextElement(string: "Title")
        stack.append(TextLayout(child: title, alignment: .horizontalCenter))
        let content = TextElement(string: "Content")
        stack.append(TextLayout(child: content, alignment: .horizontalCenter), offset: offset)
        var layout = SizeLayout(child: stack, option: .useChildSize, alignment: [.verticalCenter, .horizontalCenter])
        let parent = CGRect(x: 0, y: 44, width: 375, height: 812)
        // w
        let rect = layout.layout(in: parent)
        // t
        XCTAssertEqual(
            rect,
            CGRect(
                x: (parent.width - content.rect.width) * 0.5,
                y: title.rect.minY,
                width: content.rect.width,
                height: content.rect.maxY - title.rect.minY))
        XCTAssertEqual(title.rect.minX, (parent.width - title.rect.width) * 0.5)
        XCTAssertEqual(content.rect.minX, (parent.width - content.rect.width) * 0.5)
    }

}
