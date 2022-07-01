import UIKit

class MoreViewController: UITableViewController {
    
    private struct ControllerInstance {
        
        var viewController: UIViewController
        var presentationHandler: (UIViewController) -> Void
        
        init(controller: SupplementaryContentController) {
            viewController = controller.contentControllerFactory.makeApplicationModuleController()
            presentationHandler = controller.presentationHandler
        }
        
        func reveal() {
            presentationHandler(viewController)
        }
        
    }

    private let supplementaryContentControllers: [SupplementaryContentController]
    private var controllerInstances: [ControllerInstance] = []

    init(supplementaryApplicationModuleFactories: [SupplementaryContentController]) {
        self.supplementaryContentControllers = supplementaryApplicationModuleFactories
        super.init(style: .plain)
        
        let moreTitle = NSLocalizedString(
            "More",
            bundle: .module,
            comment: "Tab bar and navigation title for the \"More\" tab"
        )
        
        navigationItem.title = moreTitle
        tabBarItem.title = moreTitle
        tabBarItem.image = UIImage(systemName: "ellipsis")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        controllerInstances = supplementaryContentControllers
            .map(ControllerInstance.init)
    }
    
    private func applyTintColorFixForExtraTabIcons() {
        UIImageView.appearance(whenContainedInInstancesOf: [MoreViewController.self]).tintColor = .efTintColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyTintColorFixForExtraTabIcons()
        tableView.register(classForCell: SupplementaryContentControllerTableViewCell.self)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        supplementaryContentControllers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(SupplementaryContentControllerTableViewCell.self)
        let contentController = controllerInstances[indexPath.row]
        cell.applicationModuleController = contentController.viewController
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contentController = controllerInstances[indexPath.row]
        contentController.reveal()
    }
    
    private class SupplementaryContentControllerTableViewCell: UITableViewCell {
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: .default, reuseIdentifier: reuseIdentifier)
            
            accessoryType = .disclosureIndicator
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        var applicationModuleController: UIViewController? {
            didSet {
                if let supplementaryContentController = applicationModuleController {
                    textLabel?.text = supplementaryContentController.tabBarItem.title
                    
                    let image = supplementaryContentController.tabBarItem.image
                    imageView?.image = image?.withRenderingMode(.alwaysTemplate)
                }
            }
        }
        
    }

}
