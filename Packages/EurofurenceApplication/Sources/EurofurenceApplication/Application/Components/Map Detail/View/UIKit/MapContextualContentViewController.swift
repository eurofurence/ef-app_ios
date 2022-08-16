import UIKit

class MapContextualContentViewController: UIViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet private weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var topConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!

    func setContextualContent(_ content: String) {
        titleLabel.text = content
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let preferredSize = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        preferredContentSize = preferredSize
        
        // Deactivate the priority of the constraint on the opposite side of the arrow.
        // This allows us to maintain a preferred size while maintaining said size with the inclusion of the arrow.
        
        guard let popover = popoverPresentationController else { return }
        guard leftConstraint != nil,
              rightConstraint != nil,
              topConstraint != nil,
              bottomConstraint != nil else { return }
        
        var constraintsToActivate: [NSLayoutConstraint] = [
            leftConstraint,
            rightConstraint,
            topConstraint,
            bottomConstraint
        ]
        
        var constraintToDeactivate: NSLayoutConstraint?
        switch popover.arrowDirection {
        case .left:
            constraintToDeactivate = leftConstraint
            
        case .right:
            constraintToDeactivate = rightConstraint
            
        case .up:
            constraintToDeactivate = topConstraint
            
        case .down:
            constraintToDeactivate = bottomConstraint
            
        default:
            break
        }
        
        if let constraintToDeactivate = constraintToDeactivate {
            constraintsToActivate.removeAll(where: { $0 === constraintToDeactivate })
            NSLayoutConstraint.deactivate([constraintToDeactivate])
        }
        
        NSLayoutConstraint.activate(constraintsToActivate)
    }

}
