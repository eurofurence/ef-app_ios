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

        tableView.register(Header.self, forHeaderFooterViewReuseIdentifier: Header.identifier)
        tableView.register(DealerComponentTableViewCell.self)
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
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Header.identifier) as! Header
        binder?.bind(header, toDealerSearchResultGroupAt: section)
        return header
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionIndexTitles
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onDidSelectSearchResultAtIndexPath?(indexPath)
    }

    // MARK: Private

    private class Header: UITableViewHeaderFooterView, DealerGroupHeader {

        static let identifier = "Header"

        func setDealersGroupTitle(_ title: String) {
            textLabel?.text = title
        }

    }

}
