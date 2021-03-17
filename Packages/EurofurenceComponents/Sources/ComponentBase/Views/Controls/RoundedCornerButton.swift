import UIKit

@IBDesignable
public class RoundedCornerButton: UIButton {
    
    private static let standardCornerRadius: CGFloat = 7

    @IBInspectable
    public var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        cornerRadius = Self.standardCornerRadius
    }

    override public var intrinsicContentSize: CGSize {
        let defaultIntrinsicContentSize = super.intrinsicContentSize
        return CGSize(
            width: max(120, defaultIntrinsicContentSize.width),
            height: max(44, defaultIntrinsicContentSize.height)
        )
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        transitionToPressedState()
        super.touchesBegan(touches, with: event)
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        feedbackGenerator?.selectionChanged()
        transitionToUnpressedState()
        
        super.touchesEnded(touches, with: event)
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        transitionToUnpressedState()
        super.touchesCancelled(touches, with: event)
    }
    
    private var feedbackGenerator: UISelectionFeedbackGenerator?
    
    private func transitionToPressedState() {
        feedbackGenerator = UISelectionFeedbackGenerator()
        feedbackGenerator?.selectionChanged()
        
        let scaleFactor: CGFloat = 0.95
        let scaleTransform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        swapTransform(to: scaleTransform)
    }
    
    private func transitionToUnpressedState() {
        swapTransform(to: .identity)
        feedbackGenerator = nil
    }
    
    private func swapTransform(to transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.15,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: .beginFromCurrentState,
                       animations: {
            self.layer.setAffineTransform(transform)
        })
    }

}
