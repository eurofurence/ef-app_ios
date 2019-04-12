import UIKit

@IBDesignable
class UnreadIndicatorView: UIView {

    override open class var layerClass: Swift.AnyClass {
        return CAShapeLayer.self
    }

    private var shapeLayer: CAShapeLayer {
        return layer as! CAShapeLayer
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    private func setUp() {
        shapeLayer.lineWidth = 0
        shapeLayer.fillColor = UIColor.pantone330U.cgColor
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.path = UIBezierPath(ovalIn: self.bounds).cgPath
    }

}
