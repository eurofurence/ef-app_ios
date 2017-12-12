//
//  MessageBubbleBackgroundView.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UIView

@IBDesignable
class MessageBubbleBackgroundView: UIView {

    @IBInspectable var bubbleColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }

    private var cachedPath: UIBezierPath?
    private let leftInset: CGFloat = 24
    private let rightInset: CGFloat = 32
    private let cornerHeight: CGFloat = 32

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    private func setUp() {
        backgroundColor = .clear
    }

    override var frame: CGRect {
        didSet {
            updateShape()
        }
    }

    override func draw(_ rect: CGRect) {
        bubbleColor?.set()
        cachedPath?.fill()
    }

    private func updateShape() {
        let width = self.bounds.width
        let height = self.bounds.height
        let innerTipHeight: CGFloat = 7

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: height))
        path.addQuadCurve(to: CGPoint(x: leftInset, y: height - innerTipHeight), controlPoint: CGPoint(x: leftInset, y: height))
        path.addQuadCurve(to: CGPoint(x: leftInset * 2, y: height), controlPoint: CGPoint(x: leftInset, y: height))
        path.addLine(to: CGPoint(x: width - rightInset, y: height))
        path.addQuadCurve(to: CGPoint(x: width, y: height - cornerHeight), controlPoint: CGPoint(x: width, y: height))
        path.addQuadCurve(to: CGPoint(x: width, y: cornerHeight), controlPoint: CGPoint(x: width, y: 0))
        path.addQuadCurve(to: CGPoint(x: width - rightInset, y: 0), controlPoint: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: leftInset * 2, y: 0))
        path.addQuadCurve(to: CGPoint(x: leftInset / 2, y: cornerHeight), controlPoint: CGPoint(x: leftInset / 2, y: 0))
        path.addQuadCurve(to: CGPoint(x: 0, y: height), controlPoint: CGPoint(x: leftInset / 2, y: height - innerTipHeight))

        cachedPath = path
    }

}
