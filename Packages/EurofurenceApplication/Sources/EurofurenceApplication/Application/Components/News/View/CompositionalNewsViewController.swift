import ComponentBase
import UIKit

public class CompositionalNewsViewController: UIViewController, CompositionalNewsScene {
    
    private lazy var compositionalDataSource = CompositionalTableViewDataSource(tableView: tableView)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds)
        tableView.refreshControl = refreshControl
        tableView.translatesAutoresizingMaskIntoConstraints = false
        Theme.global.apply(to: tableView)
        
        return tableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl(frame: .zero)
        refreshControl.addTarget(self, action: #selector(refreshControlValueDidChange(_:)), for: .valueChanged)
        
        return refreshControl
    }()
    
    @objc private func refreshControlValueDidChange(_ sender: Any) {
        delegate?.reloadRequested()
    }
    
    private var delegate: CompositionalNewsSceneDelegate?
    public func setDelegate(_ delegate: CompositionalNewsSceneDelegate) {
        self.delegate = delegate
    }
    
    private var dataSources = [any TableViewMediator]()
    public func install(dataSource: TableViewMediator) {
        compositionalDataSource.append(dataSource)
    }
    
    public func showLoadingIndicator() {
        refreshControl.beginRefreshing()
    }
    
    public func hideLoadingIndicator() {
        refreshControl.endRefreshing()
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        installNavigationConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = [.top]
        extendedLayoutIncludesOpaqueBars = true
        
        installTableView()
        installNewsBannerImage()
        installSettingsBarButtonItem()
    }
    
    override public func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        if parent != nil {
            becomeReadyWithoutAnimations()
        }
    }
    
    private func becomeReadyWithoutAnimations() {
        UIView.setAnimationsEnabled(false)
        delegate?.sceneReady()
        UIView.setAnimationsEnabled(true)
    }
    
    private func installNavigationConfiguration() {
        navigationItem.title = .news
        tabBarItem.title = .news
        tabBarItem.image = UIImage(systemName: "newspaper", compatibleWith: traitCollection)
        tabBarItem.selectedImage = UIImage(systemName: "newspaper.fill", compatibleWith: traitCollection)
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
    
    private func installSettingsBarButtonItem() {
        let settingsBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .plain,
            target: self,
            action: #selector(openSettings(_:))
        )
        
        settingsBarButtonItem.accessibilityIdentifier = "org.eurofurence.news.settings-button"
        
        navigationItem.rightBarButtonItem = settingsBarButtonItem
    }
    
    @objc private func openSettings(_ sender: Any) {
        delegate?.settingsTapped(sender: sender)
    }
    
}
