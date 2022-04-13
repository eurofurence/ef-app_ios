import ComponentBase
import UIKit

public class CompositionalNewsViewController: UIViewController, CompositionalNewsScene {
    
    private lazy var compositionalDataSource = CompositionalTableViewDataSource(tableView: tableView)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        Theme.global.apply(to: tableView)
        
        return tableView
    }()
    
    private var delegate: CompositionalNewsSceneDelegate?
    public func setDelegate(_ delegate: CompositionalNewsSceneDelegate) {
        self.delegate = delegate
    }
    
    private var dataSources = [any TableViewMediator]()
    public func install(dataSource: TableViewMediator) {
        compositionalDataSource.append(dataSource)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = [.top]
        extendedLayoutIncludesOpaqueBars = true
        
        installNavigationConfiguration()
        installTableView()
        installNewsBannerImage()
        becomeReadyWithoutAnimations()
    }
    
    private func becomeReadyWithoutAnimations() {
        UIView.setAnimationsEnabled(false)
        delegate?.sceneReady()
        UIView.setAnimationsEnabled(true)
    }
    
    private func installNavigationConfiguration() {
        navigationItem.title = .news
        tabBarItem.title = .news
        tabBarItem.image = UIImage(named: "News", in: .module, compatibleWith: traitCollection)
    }
    
    private func installTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func installNewsBannerImage() {
        let newsBannerNib = UINib(nibName: "NewsBannerView", bundle: .module)
        let nibContents = newsBannerNib.instantiate(withOwner: nil)
        tableView.tableHeaderView = nibContents.first as? UIView
    }
    
}
