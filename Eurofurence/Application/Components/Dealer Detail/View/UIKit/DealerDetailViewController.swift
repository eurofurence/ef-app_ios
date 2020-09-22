import UIKit

class DealerDetailViewController: UIViewController, DealerDetailScene {

    // MARK: Properties
    
    private lazy var titleView = UILabel(frame: .zero)
    private unowned var titleLabelForScrollingTitleUpdates: UILabel?

    @IBOutlet private weak var tableView: UITableView!
    
    private var tableController: TableController? {
        didSet {
            tableView.dataSource = tableController
            tableView.delegate = tableController
            tableController?.scrollViewScrolled = scrollViewDidScroll(_:)
            tableController?.titleAvailable = { [weak self] (titleLabel) in
                self?.titleLabelForScrollingTitleUpdates = titleLabel
                self?.titleView.text = titleLabel.text
            }
        }
    }

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleView.accessibilityIdentifier = "org.eurofurence.dealer.navigationTitle"
        titleView.accessibilityTraits.formUnion(.header)
        titleView.font = .preferredFont(forTextStyle: .headline)
        titleView.textColor = UINavigationBar.appearance().tintColor
        navigationItem.titleView = titleView
        
        delegate?.dealerDetailSceneDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegate?.dealerDetailSceneDidAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.dealerDetailSceneDidDisappear()
    }
    
    // MARK: Title management
    
    private func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateNavigationTitle(contentOffset: scrollView.contentOffset)
    }
    
    private func updateNavigationTitle(contentOffset: CGPoint) {
        if case .visible(let opacity) = shouldShowNavigationTitle(contentOffset: contentOffset) {
            showTitle(opacity: opacity)
        } else {
            hideTitle()
        }
    }
    
    private enum TitleState {
        case visible(opacity: CGFloat)
        case hidden
    }
    
    private func shouldShowNavigationTitle(contentOffset: CGPoint) -> TitleState {
        guard let titleLabelForScrollingTitleUpdates = titleLabelForScrollingTitleUpdates else { return .hidden }
        
        let titleLabelFrame = titleLabelForScrollingTitleUpdates.frame
        let titleLabelTop = titleLabelFrame.origin.y - contentOffset.y
        let navigationTitleFrame = titleView.frame
        let additionalPaddingForAnimation: CGFloat = 20
        let navigationTitleBottom = navigationTitleFrame.origin.y + navigationTitleFrame.size.height + additionalPaddingForAnimation
        
        if titleLabelTop < navigationTitleBottom {
            let opacity = max(0, 1 - (titleLabelTop / navigationTitleBottom))
            return .visible(opacity: opacity)
        } else {
            return .hidden
        }
    }
    
    private func hideTitle() {
        titleView.isHidden = true
        titleView.alpha = 0
    }
    
    private func showTitle(opacity: CGFloat) {
        titleView.isHidden = false
        titleView.alpha = opacity
    }
    
    // MARK: Actions
    
    @IBAction private func shareButtonTapped(_ sender: Any) {
        delegate?.dealerDetailSceneDidTapShareButton(sender)
    }
    
    // MARK: DealerDetailScene

    private var delegate: DealerDetailSceneDelegate?
    func setDelegate(_ delegate: DealerDetailSceneDelegate) {
        self.delegate = delegate
    }

    func bind(numberOfComponents: Int, using binder: DealerDetailSceneBinder) {
        tableController = TableController(
            tableView: tableView,
            numberOfComponents: numberOfComponents,
            binder: binder
        )
    }

    // MARK: Private

    private class TableController: NSObject, UITableViewDataSource, UITableViewDelegate, DealerDetailItemComponentFactory {

        private let tableView: UITableView
        private let numberOfComponents: Int
        private let binder: DealerDetailSceneBinder
        var titleAvailable: ((UILabel) -> Void)?
        var scrollViewScrolled: ((UIScrollView) -> Void)?

        init(tableView: UITableView, numberOfComponents: Int, binder: DealerDetailSceneBinder) {
            self.tableView = tableView
            self.numberOfComponents = numberOfComponents
            self.binder = binder
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return numberOfComponents
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return binder.bindComponent(at: indexPath.row, using: self)
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            scrollViewScrolled?(scrollView)
        }

        func makeDealerSummaryComponent(configureUsing block: (DealerDetailSummaryComponent) -> Void) -> UITableViewCell {
            let cell = tableView.dequeue(DealerDetailSummaryTableViewCell.self)
            block(cell)
            
            titleAvailable?(cell.dealerTitleLabel)
            
            return cell
        }

        func makeDealerLocationAndAvailabilityComponent(configureUsing block: (DealerLocationAndAvailabilityComponent) -> Void) -> UITableViewCell {
            let cell = tableView.dequeue(DealerDetailLocationAndAvailabilityTableViewCell.self)
            block(cell)
            return cell
        }

        func makeAboutTheArtistComponent(configureUsing block: (DealerAboutTheArtistComponent) -> Void) -> UITableViewCell {
            let cell = tableView.dequeue(DealerAboutTheArtistTableViewCell.self)
            block(cell)
            return cell
        }

        func makeAboutTheArtComponent(configureUsing block: (AboutTheArtComponent) -> Void) -> Component {
            let cell = tableView.dequeue(AboutTheArtTableViewCell.self)
            block(cell)
            return cell
        }

    }

}
