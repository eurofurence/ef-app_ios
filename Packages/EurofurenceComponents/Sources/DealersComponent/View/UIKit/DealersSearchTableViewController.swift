import UIKit

class DealersSearchTableViewController: UITableViewController {

    // MARK: Functions

    var onDidSelectSearchResultAtIndexPath: ((IndexPath) -> Void)?
    private var numberOfDealersPerSection: [Int] = []
    private var sectionIndexTitles: [String]?
    private var binder: DealersSearchResultsBinder?

    func bindSearchResults(numberOfDealersPerSection: [Int],
                           sectionIndexTitles: [String],
                           using binder: DealersSearchResultsBinder) {
        self.numberOfDealersPerSection = numberOfDealersPerSection
        self.sectionIndexTitles = sectionIndexTitles
        self.binder = binder

        tableView.reloadData()
    }

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        let cellName = String(describing: DealerComponentTableViewCell.self)
        let cellNib = UINib(nibName: cellName, bundle: .module)
        tableView.register(cellNib, forCellReuseIdentifier: cellName)
        
        tableView.registerConventionBrandedHeader()
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfDealersPerSection.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfDealersPerSection[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(DealerComponentTableViewCell.self)
        binder?.bind(cell, toDealerSearchResultAt: indexPath)
        return cell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueConventionBrandedHeader()
        binder?.bind(header, toDealerSearchResultGroupAt: section)
        return header
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionIndexTitles
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        onDidSelectSearchResultAtIndexPath?(indexPath)
    }

}
