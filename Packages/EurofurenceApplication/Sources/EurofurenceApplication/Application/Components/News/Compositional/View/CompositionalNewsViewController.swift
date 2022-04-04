import ComponentBase
import UIKit

public class CompositionalNewsViewController: UIViewController, NewsWidgetManager {
    
    private var compositionalDataSource: CompositionalTableViewDataSource!
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        Theme.global.apply(to: tableView)
        
        return tableView
    }()
    
    public func install(dataSource: TableViewMediator) {
        
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = [.top]
        extendedLayoutIncludesOpaqueBars = true
        
        installNavigationConfiguration()
        installTableView()
        installNewsBannerImage()
        prepareCompositionalDataSource()
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
    
    private func prepareCompositionalDataSource() {
        compositionalDataSource = CompositionalTableViewDataSource(tableView: tableView)
    }
    
}
