import UIKit

@IBDesignable
class RoundedCornerButton: UIButton {

    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 45)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        transitionToPressedState()
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        feedbackGenerator?.selectionChanged()
        transitionToUnpressedState()
        
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
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
