import UIKit

public class AspectRatioConstrainedImageView: UIImageView {

    private var aspectRatioConstraint: NSLayoutConstraint?

    override public var image: UIImage? {
        didSet {
            aspectRatioConstraint.map(removeConstraint)
            aspectRatioConstraint = nil
            
            if let image = image {
                let size = image.size
                let constraint = NSLayoutConstraint(
                    item: self,
                    attribute: .width,
                    relatedBy: .equal,
                    toItem: self,
                    attribute: .height,
                    multiplier: size.width / size.height,
                    constant: 0
                )
                
                constraint.identifier = "Image Aspect Ratio"
                constraint.priority = .defaultHigh
                
                addConstraint(constraint)
                aspectRatioConstraint = constraint
            }
        }
    }
    
}
