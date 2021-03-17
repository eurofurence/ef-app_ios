import UIKit

public class DissolvingTitleLabel: UILabel {
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        accessibilityTraits.formUnion(.header)
        font = .preferredFont(forTextStyle: .headline)
        textColor = UINavigationBar.appearance().tintColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
