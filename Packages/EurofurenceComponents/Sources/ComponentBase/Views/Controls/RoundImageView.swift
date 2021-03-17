import UIKit

public class RoundImageView: UIImageView {
    
    override public init(frame: CGRect) {
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
    
    override public var frame: CGRect {
        didSet {
            layer.cornerRadius = frame.width / 2
        }
    }

}
