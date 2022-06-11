import UIKit

public class AspectRatioConstrainedImageView: UIImageView {

    private var aspectRatioConstraint: NSLayoutConstraint?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentMode = .scaleAspectFit
    }
    
    override public var image: UIImage? {
        didSet {
            aspectRatioConstraint.map(removeConstraint)
            aspectRatioConstraint = nil
            
            if let image = image {
                let size = image.size
                let constraint = NSLayoutConstraint(
                    item: self,
                    attribute: .height,
                    relatedBy: .equal,
                    toItem: self,
                    attribute: .width,
                    multiplier: size.height / size.width,
                    constant: 0
                )
                
                constraint.identifier = "Image Aspect Ratio"
                constraint.priority = .defaultHigh
                
                aspectRatioConstraint = constraint
                constraint.isActive = true
            }
        }
    }
    
    override public var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
    }
    
}
