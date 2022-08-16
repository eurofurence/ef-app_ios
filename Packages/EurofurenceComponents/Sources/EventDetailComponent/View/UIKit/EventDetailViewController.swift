import ComponentBase
import UIKit

class EventDetailViewController: UIViewController, EventDetailScene {

    // MARK: Properties
    
    private var titleController: DissolvingTitleController?
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.accessibilityIdentifier = "org.eurofurence.EventDetail.table"
        }
    }
    
    private var tableController: TableController?

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Theme.global.apply(to: tableView)
        addEmptyBarItemToFixCustomTitleViewsNotAppearing()
        delegate?.eventDetailSceneDidLoad()
    }
    
    private func addEmptyBarItemToFixCustomTitleViewsNotAppearing() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: UIView(frame: .zero))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegate?.eventDetailSceneDidAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.eventDetailSceneDidDisappear()
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
        
        tableController?.titleAvailable = { [weak self] (titleLabel) in
            guard let self = self else { return }
            
            self.titleController = DissolvingTitleController(
                scrollView: self.tableView,
                navigationItem: self.navigationItem,
                accessibilityIdentifier: "org.eurofurence.event.navigationTitle",
                context: DissolvingTitleLabelContext(label: titleLabel)
            )
        }
    }

    // MARK: Private

    private class TableController: NSObject, UITableViewDataSource, EventDetailItemComponentFactory {

        private let tableView: UITableView
        private let numberOfComponents: Int
        private let binder: EventDetailBinder
        var titleAvailable: ((UILabel) -> Void)?

        init(tableView: UITableView, numberOfComponents: Int, binder: EventDetailBinder) {
            self.tableView = tableView
            self.numberOfComponents = numberOfComponents
            self.binder = binder
            super.init()

            tableView.dataSource = self
        }

        // MARK: EventDetailComponentFactory

        func makeEventSummaryComponent(configuringUsing block: (EventSummaryComponent) -> Void) -> UITableViewCell {
            let cell = tableView.dequeue(EventDetailSummaryTableViewCell.self)
            block(cell)
            
            cell.yieldTitleLabel(to: titleAvailable)
            
            return cell
        }

        func makeEventDescriptionComponent(
            configuringUsing block: (EventDescriptionComponent) -> Void
        ) -> UITableViewCell {
            let cell = tableView.dequeue(EventDetailDescriptionTableViewCell.self)
            block(cell)
            return cell
        }

        func makeEventGraphicComponent(configuringUsing block: (EventGraphicComponent) -> Void) -> UITableViewCell {
            let cell = tableView.dequeue(EventDetailBannerTableViewCell.self)
            block(cell)
            return cell
        }

        func makeSponsorsOnlyBannerComponent(
            configuringUsing block: (EventInformationBannerComponent) -> Void
        ) -> UITableViewCell {
            return makeBannerComponent(icons: .sponsor, configuration: block)
        }

        func makeSuperSponsorsOnlyBannerComponent(
            configuringUsing block: (EventInformationBannerComponent) -> Void
        ) -> UITableViewCell {
            return makeBannerComponent(icons: .superSponsor, configuration: block)
        }

        func makeArtShowBannerComponent(
            configuringUsing block: (EventInformationBannerComponent) -> Void
        ) -> UITableViewCell {
            return makeBannerComponent(icons: .artshow, configuration: block)
        }

        func makeKageBannerComponent(
            configuringUsing block: (EventInformationBannerComponent) -> Void
        ) -> UITableViewCell {
            return makeBannerComponent(icons: .bug, configuration: block)
        }

        func makeDealersDenBannerComponent(
            configuringUsing block: (EventInformationBannerComponent) -> Void
        ) -> UITableViewCell {
            return makeBannerComponent(icons: .dealersDen, configuration: block)
        }

        func makeMainStageBannerComponent(
            configuringUsing block: (EventInformationBannerComponent) -> Void
        ) -> UITableViewCell {
            return makeBannerComponent(icons: .mainStage, configuration: block)
        }

        func makePhotoshootBannerComponent(
            configuringUsing block: (EventInformationBannerComponent) -> Void
        ) -> UITableViewCell {
            return makeBannerComponent(icons: .photoshoot, configuration: block)
        }
        
        func makeFaceMaskBannerComponent(
            configuringUsing block: (EventInformationBannerComponent) -> Void
        ) -> UITableViewCell {
            return makeBannerComponent(icons: .faceMaskRequired, configuration: block)
        }
        
        func makeEventActionBannerComponent(
            configuringUsing block: (EventActionBannerComponent) -> Void
        ) -> UITableViewCell {
            let cell = tableView.dequeue(EventActionBannerTableViewCell.self)
            block(cell)
            return cell
        }

        // MARK: UITableViewDataSource

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return numberOfComponents
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return binder.bindComponent(at: indexPath, using: self)
        }

        // MARK: Private

        private func makeBannerComponent(
            icons: IconView.Icon ...,
            configuration: (EventInformationBannerComponent) -> Void
        ) -> UITableViewCell {
            let cell = tableView.dequeue(EventInformationBannerTableViewCell.self)
            configuration(cell)
            cell.configureIcons(icons: icons)

            return cell
        }

    }

}
