//
//  StackLayoutBuilder.swift
//

import CoreGraphics

@_functionBuilder
public struct StackLayoutBuilder {

    public typealias FactoryMethod = (_ axis: Axis) -> StackLayout.LayoutElement

    public static func buildBlock(_ layouts: Layout...) -> [FactoryMethod] {
        layouts.map { layout in
            { axis in
                if let block = layout as? Block {
                    return make(from: block, axis: axis)
                }
                return .init(
                    child: layout,
                    point: .init(axis: axis, offset: 0, crossOffset: 0),
                    flexible: [])
            }
        }
    }

    private static func make(from block: Block, axis: Axis) -> StackLayout.LayoutElement {
        switch block.length {
        case .none:
            return .init(
                child: block.child,
                point: .init(axis: axis, offset: block.offset, crossOffset: block.crossOffset),
                flexible: block.flexible)
        case let .some(length):
            return .init(
                child: SizeLayout(child: block.child, size: .init(axis: axis, length: length, crossLength: 0)),
                point: .init(axis: axis, offset: block.offset, crossOffset: block.crossOffset),
                flexible: block.flexible)
        }
    }

}

extension Layout {

    func length(_ value: CGFloat) -> Block {
        write(value, keyPath: \Block.length)
    }

    func offset(_ value: CGFloat) -> Block {
        write(value, keyPath: \Block.offset)
    }

    func crossOffset(_ value: CGFloat) -> Block {
        write(value, keyPath: \Block.crossOffset)
    }

    func flexible(_ value: Flexible) -> Block {
        write(value, keyPath: \Block.flexible)
    }

    private func write<T>(_ value: T, keyPath: WritableKeyPath<Block, T>) -> Block {
        var block = self as? Block ?? .init(child: self)
        block[keyPath: keyPath] = value
        return block
    }

}

public struct Block: Layout {

    public private(set) var child: Layout
    public var length: CGFloat?
    public var offset: CGFloat
    public var crossOffset: CGFloat
    public var flexible: Flexible

    public init(child: Layout, length: CGFloat? = nil, offset: CGFloat = 0, crossOffset: CGFloat = 0, flexible: Flexible = []) {
        self.length = length
        self.child = child
        self.offset = offset
        self.crossOffset = crossOffset
        self.flexible = flexible
    }

    public mutating func layout(in rect: CGRect) -> CGRect {
        child.layout(in: rect)
    }

    public func calculateSize(in rect: CGRect) -> CGSize {
        child.calculateSize(in: rect)
    }

}
