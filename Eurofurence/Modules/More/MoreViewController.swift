import UIKit

class MoreViewController: UITableViewController {
    
    private let supplementaryContentControllerFactories: [ContentControllerFactory]
    private var supplementaryContentControllers: [UIViewController] = []

    init(supplementaryContentControllerFactories: [ContentControllerFactory]) {
        self.supplementaryContentControllerFactories = supplementaryContentControllerFactories
        super.init(style: .plain)
        
        let moreTitle = NSLocalizedString(
            "More",
            comment: "Tab bar and navigation title for the \"More\" tab"
        )
        
        navigationItem.title = moreTitle
        tabBarItem.title = moreTitle
        tabBarItem.image = UIImage(named: "More")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        supplementaryContentControllers = supplementaryContentControllerFactories
            .map({ $0.makeContentController() })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(classForCell: SupplementaryContentControllerTableViewCell.self)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        supplementaryContentControllers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(SupplementaryContentControllerTableViewCell.self)
        let contentController = supplementaryContentControllers[indexPath.row]
        cell.supplementaryContentController = contentController
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contentController = supplementaryContentControllers[indexPath.row]
        show(contentController, sender: self)
    }
    
    private class SupplementaryContentControllerTableViewCell: UITableViewCell {
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: .default, reuseIdentifier: reuseIdentifier)
            
            accessoryType = .disclosureIndicator
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        var supplementaryContentController: UIViewController? {
            didSet {
                if let supplementaryContentController = supplementaryContentController {
                    textLabel?.text = supplementaryContentController.tabBarItem.title
                    
                    let image = supplementaryContentController.tabBarItem.image
                    imageView?.image = image?.withRenderingMode(.alwaysTemplate)
                    imageView?.tintColor = .pantone330U
                }
            }
        }
        
    }

}
