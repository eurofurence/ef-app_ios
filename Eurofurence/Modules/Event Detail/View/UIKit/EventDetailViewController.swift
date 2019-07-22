import UIKit

class EventDetailViewController: UIViewController, EventDetailScene {

    // MARK: Properties

    @IBOutlet private weak var tableView: UITableView!
    private var tableController: TableController?

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
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

    // MARK: EventDetailScene

    private var delegate: EventDetailSceneDelegate?
    func setDelegate(_ delegate: EventDetailSceneDelegate) {
        self.delegate = delegate
    }

    func bind(numberOfComponents: Int, using binder: EventDetailBinder) {
        tableController = TableController(tableView: tableView,
                                          numberOfComponents: numberOfComponents,
                                          binder: binder)
    }

    // MARK: Private

    private class TableController: NSObject, UITableViewDataSource, EventDetailComponentFactory {

        private let tableView: UITableView
        private let numberOfComponents: Int
        private let binder: EventDetailBinder

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
            cell.configureIcon(text: text, textColor: .pantone330U)

            return cell
        }

    }

}
