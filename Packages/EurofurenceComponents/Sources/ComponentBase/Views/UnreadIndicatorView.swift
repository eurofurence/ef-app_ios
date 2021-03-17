import UIKit

@IBDesignable
public class UnreadIndicatorView: UIView {

    override open class var layerClass: Swift.AnyClass {
        return CAShapeLayer.self
    }

    private var shapeLayer: CAShapeLayer {
        guard let underlyingLayer = layer as? CAShapeLayer else {
            fatalError("The layer for \(UnreadIndicatorView.self) changed since using \(CAShapeLayer.self)")
        }
        
        return underlyingLayer
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override public func tintColorDidChange() {
        super.tintColorDidChange()
        shapeLayer.fillColor = tintColor.cgColor
    }

    private func setUp() {
        shapeLayer.lineWidth = 0
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.path = UIBezierPath(ovalIn: self.bounds).cgPath
    }

}
