
import XCTest

@testable import Outline

final class StackLayoutTests : XCTestCase {

    func testFlexLenght2StaticFlexMiddle() {
        // g
        let length: CGFloat = 44
        var layout = StackLayout(axis: .x)
        let s1 = Element()
        layout.append(s1, length: length, crossOffset: 10)
        let f1 = Element()
        layout.append(f1, flexible: .length)
        let s2 = Element()
        layout.append(s2, length: length)
        let parent = CGRect(origin: .zero, size: CGSize(width: 375, height: length))
        // w
        let rect = layout.layout(in: parent)
        // t
        let efl = parent.width - length * 2
        XCTAssertEqual(rect, parent)
        XCTAssertEqual(s1.rect, CGRect(x: 0, y: 10, width: length, height: length))
        XCTAssertEqual(f1.rect, CGRect(x: s1.rect.maxX, y: 0, width: efl, height: length))
        XCTAssertEqual(s2.rect, CGRect(x: f1.rect.maxX, y: 0, width: length, height: length))
    }

    func testFlexLenghtStaticFlexStaticFlexStatic() {
        // g
        var layout = StackLayout(axis: .x)
        let s1 = Element()
        let length: CGFloat = 44
        layout.append(s1, length: length)
        let f1 = Element()
        layout.append(f1, flexible: .length)
        let s2 = Element()
        layout.append(s2, length: length)
        let f2 = Element()
        layout.append(f2, flexible: .length)
        let s3 = Element()
        layout.append(s3, length: length)
        let parent = CGRect(origin: .zero, size: CGSize(width: 375, height: length))
        // w
        let rect = layout.layout(in: parent)
        // t
        let efl = (parent.width - length * 3) / 2
        XCTAssertEqual(rect, parent)
        XCTAssertEqual(s1.rect, CGRect(x: 0, y: 0, width: length, height: length))
        XCTAssertEqual(f1.rect, CGRect(x: length, y: 0, width: efl, height: length))
        XCTAssertEqual(s2.rect, CGRect(x: length + efl, y: 0, width: length, height: length))
        XCTAssertEqual(f2.rect, CGRect(x: length + efl + length, y: 0, width: efl, height: length))
        XCTAssertEqual(s3.rect, CGRect(x: length + efl + length + efl, y: 0, width: length, height: length))
    }

    func testFlexLenghtStatic2FlexStatic() {
        // g
        var layout = StackLayout(axis: .x)
        let s1 = Element()
        let length: CGFloat = 44
        layout.append(s1, length: length)
        let f1 = Element()
        layout.append(f1, flexible: .length)
        let f2 = Element()
        layout.append(f2, flexible: .length)
        let s2 = Element()
        layout.append(s2, length: length)
        let parent = CGRect(origin: .zero, size: CGSize(width: 375, height: length))
        // w
        let rect = layout.layout(in: parent)
        // t
        let efl = (parent.width - length * 2) / 2
        XCTAssertEqual(rect, parent)
        XCTAssertEqual(s1.rect, CGRect(x: 0, y: 0, width: length, height: length))
        XCTAssertEqual(f1.rect, CGRect(x: length, y: 0, width: efl, height: length))
        XCTAssertEqual(f2.rect, CGRect(x: length + efl, y: 0, width: efl, height: length))
        XCTAssertEqual(s2.rect, CGRect(x: length + efl + efl, y: 0, width: length, height: length))
    }

    func testNestedFlexStackLayout() {
        // g
        let length: CGFloat = 64
        let offset: CGFloat = 10
        var layout = StackLayout(axis: .x)
        let s1 = Element()
        layout.append(s1, length: length)
        var hStack = StackLayout(axis: .y)
        let t1 = TextElement(string: "John Wick")
        hStack.append(TextLayout(child: t1, options: [.parentWidth]))
        let t2 = TextElement(string: "@jwck")
        hStack.append(TextLayout(child: t2, options: [.parentWidth]))
        layout.append(hStack, offset: offset, flexible: .length)
        let s2 = Element()
        layout.append(s2, length: length, offset: offset)
        let parent = CGRect(origin: .zero, size: CGSize(width: 375, height: length))
        // w
        let rect = layout.layout(in: parent)
        // t
        let efl = parent.width - (length + offset) * 2
        XCTAssertEqual(rect, parent)
        XCTAssertEqual(s1.rect, CGRect(x: 0, y: 0, width: length, height: length))
        XCTAssertEqual(t1.rect, CGRect(x: length + offset, y: 0, width: efl, height: t1.rect.height))
        XCTAssertEqual(t2.rect, CGRect(x: length + offset, y: t1.rect.maxY, width: efl, height: t2.rect.height))
        XCTAssertEqual(s2.rect, CGRect(x: length + offset + efl + offset, y: 0, width: length, height: length))
    }

    func testFlexStatic() {
        // g
        let length: CGFloat = 44
        let offset: CGFloat = 10
        var layout = StackLayout(axis: .x)
        let f1 = Element()
        layout.append(f1, flexible: .length)
        let s1 = Element()
        layout.append(s1, length: length, offset: offset)
        let parent = CGRect(origin: .zero, size: CGSize(width: 375, height: 64))
        // w
        let rect = layout.layout(in: parent)
        // t
        let efl = parent.width - length - offset
        XCTAssertEqual(rect, parent)
        XCTAssertEqual(f1.rect, CGRect(x: 0, y: 0, width: efl, height: parent.height))
        XCTAssertEqual(s1.rect, CGRect(x: efl + offset, y: 0, width: length, height: parent.height))
    }

    func testFlexForStaticSizeLayout() {
        // g
        let length: CGFloat = 44
        var layout = StackLayout(axis: .x)
        let s1 = Element()
        layout.append(SizeLayout(child: s1, side: length))
        let s2 = Element()
        layout.append(SizeLayout(child: s2, side: length), flexible: .length)
        let s3 = Element()
        layout.append(SizeLayout(child: s3, side: length))
        let parent = CGRect(origin: .zero, size: CGSize(width: 375, height: 64))
        // w
        let rect = layout.layout(in: parent)
        // t
        XCTAssertEqual(rect, CGRect(x: 0, y: 0, width: length * 3, height: length))
        XCTAssertEqual(s1.rect, CGRect(x: 0, y: 0, width: length, height: length))
        XCTAssertEqual(s2.rect, CGRect(x: length, y: 0, width: length, height: length))
        XCTAssertEqual(s3.rect, CGRect(x: length * 2, y: 0, width: length, height: length))
    }

    func testBuilder() {
        // g
        let length: CGFloat = 44
        let s1 = Element()
        let f1 = Element()
        let s2 = Element()
        var layout = StackLayout(axis: .x) {
            s1
                .length(length)
                .crossOffset(10)
                .offset(5)
            SizeLayout(child: f1)
                .flexible(.length)
            SizeLayout(child: s2, width: length)
        }
        let parent = CGRect(origin: .zero, size: CGSize(width: 375, height: length))
        // w
        let rect = layout.layout(in: parent)
        // t
        let efl = parent.width - length * 2 - 5
        XCTAssertEqual(rect, parent)
        XCTAssertEqual(s1.rect, CGRect(x: 5, y: 10, width: length, height: length))
        XCTAssertEqual(f1.rect, CGRect(x: s1.rect.maxX, y: 0, width: efl, height: length))
        XCTAssertEqual(s2.rect, CGRect(x: f1.rect.maxX, y: 0, width: length, height: length))
    }
  
    func testLayoutWithZeroLengths() {
        // g
        let elements = [Element(), Element(), Element(), Element(), Element()]
        let heights: [CGFloat] = [0, 64, 128, 256, 0]
        var layout = StackLayout(axis: .y)
        for (element, height) in zip(elements, heights) {
            layout.append(element, length: height)
        }
        let parent = CGRect(origin: .zero, size: .init(width: 375, height: heights.reduce(0, +)))
        // w
        let rect = layout.layout(in: parent)
        // t
        XCTAssertEqual(rect, parent)
        for (element, height) in zip(elements, heights) {
            XCTAssertEqual(element.rect.height, height)
        }
    }

}
