import UIKit

public class ConventionBrandedTableViewHeaderFooterView: UITableViewHeaderFooterView {
    
    public static let identifier = "Header"
    
    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    private func setUp() {
        backgroundView = ConventionNavigationBarColorView()
    }
    
}
