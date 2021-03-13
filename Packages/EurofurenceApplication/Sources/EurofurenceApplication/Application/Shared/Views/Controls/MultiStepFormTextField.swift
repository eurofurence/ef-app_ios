import UIKit

class MultiStepFormTextField: UITextField {
    
    // swiftlint:disable private_outlet
    @IBOutlet var nextField: UITextField?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    private func setUp() {
        addTarget(self, action: #selector(editingDidEnd), for: .editingDidEndOnExit)
    }
    
    @objc private func editingDidEnd() {
        if let nextField = nextField, nextField.canBecomeFirstResponder {
            nextField.becomeFirstResponder()
        }
    }
    
}
