import UIKit

class DealerDetailViewController: UIViewController, DealerDetailScene {

    // MARK: Properties
    
    private var titleController: DissolvingTitleController?

    @IBOutlet private weak var tableView: UITableView!
    
    private var tableController: TableController? {
        didSet {
            tableView.dataSource = tableController
            tableController?.titleAvailable = { [weak self] (titleLabel) in
                guard let self = self else { return }
                
                self.titleController = DissolvingTitleController(
                    scrollView: self.tableView,
                    navigationItem: self.navigationItem,
                    accessibilityIdentifier: "org.eurofurence.dealer.navigationTitle",
                    context: DissolvingTitleLabelContext(label: titleLabel)
                )
            }
        }
    }

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
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

    private class TableController: NSObject, UITableViewDataSource, DealerDetailItemComponentFactory {

        private let tableView: UITableView
        private let numberOfComponents: Int
        private let binder: DealerDetailSceneBinder
        var titleAvailable: ((UILabel) -> Void)?

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

        func makeDealerSummaryComponent(configureUsing block: (DealerDetailSummaryComponent) -> Void) -> UITableViewCell {
            let cell = tableView.dequeue(DealerDetailSummaryTableViewCell.self)
            block(cell)
            
            cell.yieldTitleLabel(to: titleAvailable)
            
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
