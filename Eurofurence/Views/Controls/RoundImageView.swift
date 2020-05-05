import UIKit

class RoundImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        layer.masksToBounds = true
    }
    
    override var frame: CGRect {
        didSet {
            layer.cornerRadius = frame.width / 2
        }
    }

}
