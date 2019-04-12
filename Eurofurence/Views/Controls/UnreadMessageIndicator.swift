import UIKit

@IBDesignable
class UnreadMessageIndicator: UIView {

    override var frame: CGRect {
        didSet {
            layer.cornerRadius = frame.height / 2
        }
    }

}
