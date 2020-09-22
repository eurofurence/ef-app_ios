import UIKit

class EventDetailViewController: UIViewController, EventDetailScene {

    // MARK: Properties

    private lazy var titleView = DissolvingTitleLabel(frame: .zero)
    private var titleLabelForScrollingTitleUpdates: UILabel?
    @IBOutlet private weak var tableView: UITableView!
    private var tableController: TableController?

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleView.accessibilityIdentifier = "org.eurofurence.event.navigationTitle"
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: UIView(frame: .zero))
        
        delegate?.eventDetailSceneDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegate?.eventDetailSceneDidAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.eventDetailSceneDidDisappear()
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

    // MARK: EventDetailScene

    private var delegate: EventDetailSceneDelegate?
    func setDelegate(_ delegate: EventDetailSceneDelegate) {
        self.delegate = delegate
    }

    func bind(numberOfComponents: Int, using binder: EventDetailBinder) {
        tableController = TableController(tableView: tableView,
                                          numberOfComponents: numberOfComponents,
                                          binder: binder)
        
        tableController?.scrollViewScrolled = scrollViewDidScroll(_:)
        tableController?.titleAvailable = { [weak self] (titleLabel) in
            self?.titleLabelForScrollingTitleUpdates = titleLabel
            self?.titleView.text = titleLabel.text
        }
    }

    // MARK: Private

    private class TableController: NSObject, UITableViewDataSource, UITableViewDelegate, EventDetailItemComponentFactory {

        private let tableView: UITableView
        private let numberOfComponents: Int
        private let binder: EventDetailBinder
        var titleAvailable: ((UILabel) -> Void)?
        var scrollViewScrolled: ((UIScrollView) -> Void)?

        init(tableView: UITableView, numberOfComponents: Int, binder: EventDetailBinder) {
            self.tableView = tableView
            self.numberOfComponents = numberOfComponents
            self.binder = binder
            super.init()

            tableView.dataSource = self
            tableView.delegate = self
        }

        // MARK: EventDetailComponentFactory

        func makeEventSummaryComponent(configuringUsing block: (EventSummaryComponent) -> Void) -> UITableViewCell {
            let cell = tableView.dequeue(EventDetailSummaryTableViewCell.self)
            block(cell)
            
            cell.yieldTitleLabel(to: titleAvailable)
            
            return cell
        }

        func makeEventDescriptionComponent(configuringUsing block: (EventDescriptionComponent) -> Void) -> UITableViewCell {
            let cell = tableView.dequeue(EventDetailDescriptionTableViewCell.self)
            block(cell)
            return cell
        }

        func makeEventGraphicComponent(configuringUsing block: (EventGraphicComponent) -> Void) -> UITableViewCell {
            let cell = tableView.dequeue(EventDetailBannerTableViewCell.self)
            block(cell)
            return cell
        }

        func makeSponsorsOnlyBannerComponent(configuringUsing block: (EventInformationBannerComponent) -> Void) -> UITableViewCell {
            return makeBannerComponent(text: "", configuration: block)
        }

        func makeSuperSponsorsOnlyBannerComponent(configuringUsing block: (EventInformationBannerComponent) -> Void) -> UITableViewCell {
            return makeBannerComponent(text: "", configuration: block)
        }

        func makeArtShowBannerComponent(configuringUsing block: (EventInformationBannerComponent) -> Void) -> UITableViewCell {
            return makeBannerComponent(text: "\u{f03e}", configuration: block)
        }

        func makeKageBannerComponent(configuringUsing block: (EventInformationBannerComponent) -> Void) -> UITableViewCell {
            return makeBannerComponent(text: "\u{f000}\u{f188}", configuration: block)
        }

        func makeDealersDenBannerComponent(configuringUsing block: (EventInformationBannerComponent) -> Void) -> UITableViewCell {
            return makeBannerComponent(text: "\u{f07a}", configuration: block)
        }

        func makeMainStageBannerComponent(configuringUsing block: (EventInformationBannerComponent) -> Void) -> UITableViewCell {
            return makeBannerComponent(text: "\u{f069}", configuration: block)
        }

        func makePhotoshootBannerComponent(configuringUsing block: (EventInformationBannerComponent) -> Void) -> UITableViewCell {
            return makeBannerComponent(text: "\u{f030}", configuration: block)
        }
        
        func makeEventActionBannerComponent(configuringUsing block: (EventActionBannerComponent) -> Void) -> UITableViewCell {
            let cell = tableView.dequeue(EventActionBannerTableViewCell.self)
            block(cell)
            return cell
        }
        
        // MARK: UIScrollViewDelegate
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            scrollViewScrolled?(scrollView)
        }

        // MARK: UITableViewDataSource

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return numberOfComponents
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return binder.bindComponent(at: indexPath, using: self)
        }

        // MARK: Private

        private func makeBannerComponent(text: String, configuration: (EventInformationBannerComponent) -> Void) -> UITableViewCell {
            let cell = tableView.dequeue(EventInformationBannerTableViewCell.self)
            configuration(cell)
            cell.configureIcon(text: text)

            return cell
        }

    }

}
