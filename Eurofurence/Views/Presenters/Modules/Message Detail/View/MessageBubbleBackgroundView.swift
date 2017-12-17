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

    private let leftContentInset: CGFloat = 14
    private let rightContentInset: CGFloat = 18
    private let cornerHeight: CGFloat = 24

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

    override var bounds: CGRect {
        didSet {
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        bubbleColor?.set()
        makeBubblePath().fill()
    }

    private func makeBubblePath() -> UIBezierPath {
        let width = self.bounds.width
        let height = self.bounds.height
        let innerTipHeight: CGFloat = 7

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: height))
        path.addQuadCurve(to: CGPoint(x: leftContentInset, y: height - innerTipHeight), controlPoint: CGPoint(x: leftContentInset / 2, y: height))
        path.addQuadCurve(to: CGPoint(x: leftContentInset * 2, y: height), controlPoint: CGPoint(x: 1.25 * leftContentInset, y: height))
        path.addLine(to: CGPoint(x: width - rightContentInset, y: height))
        path.addQuadCurve(to: CGPoint(x: width, y: height - cornerHeight), controlPoint: CGPoint(x: width, y: height))
        path.addQuadCurve(to: CGPoint(x: width, y: cornerHeight), controlPoint: CGPoint(x: width, y: 0))
        path.addQuadCurve(to: CGPoint(x: width - rightContentInset, y: 0), controlPoint: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: leftContentInset * 2, y: 0))
        path.addQuadCurve(to: CGPoint(x: leftContentInset / 2, y: cornerHeight), controlPoint: CGPoint(x: leftContentInset / 2, y: 0))
        path.addQuadCurve(to: CGPoint(x: 0, y: height), controlPoint: CGPoint(x: leftContentInset / 2, y: height - innerTipHeight))

        return path
    }

}
