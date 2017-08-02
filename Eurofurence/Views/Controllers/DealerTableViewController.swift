//
//  DealerTableViewController.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import ReactiveSwift

class DealerTableViewController: UITableViewController {
	let dataContext: DataContextProtocol = try! ContextResolver.container.resolve()
	var dealersByLetter: [String: [Dealer]] = [:]
	var sortedKeys: [String] = []
	var disposable = CompositeDisposable()

    deinit {
        disposable.dispose()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor =  UIColor(patternImage: #imageLiteral(resourceName: "Background Tile"))
        refreshControl?.addTarget(self, action: #selector(DealerTableViewController.refresh(_:)),
                                  for: UIControlEvents.valueChanged)

        disposable += dataContext.Dealers.signal
            .observe(on: QueueScheduler.concurrent).observe({ [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.orderDealersAlphabeticaly(strongSelf.dataContext.Dealers.value)
                strongSelf.tableView.reloadData()
            })

        orderDealersAlphabeticaly(dataContext.Dealers.value)
        tableView.reloadData()

        guard let refreshControl = refreshControl else { return }

        let refreshControlVisibilityDelegate = RefreshControlDataStoreDelegate(refreshControl: refreshControl)
        DataStoreRefreshController.shared.add(refreshControlVisibilityDelegate)
    }

    func canRotate() -> Bool {
        return true
	}

	// TODO: Pull into super class for all refreshable ViewControllers
	/// Initiates sync with API via refreshControl
	func refresh(_ sender: AnyObject) {
		DataStoreRefreshController.shared.refreshStore()
	}

	override func viewWillDisappear(_ animated: Bool) {
		refreshControl?.endRefreshing()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
	}

	private func orderDealersAlphabeticaly(_ dealers: [Dealer]) {
		// TODO: Insert sync barrier
		dealersByLetter.removeAll()
		for dealer in dealers {
			var dealerName: String?

			if !dealer.DisplayName.isEmpty {
				dealerName = dealer.DisplayName
			} else if !dealer.AttendeeNickname.isEmpty {
				dealerName = dealer.AttendeeNickname
			}

			if let dealerName = dealerName {
				let dealerLetter: String
				if #available(iOS 9.0, *) {
					dealerLetter = String(dealerName.localizedUppercase[dealerName.startIndex])
				} else {
					dealerLetter = String(dealerName.uppercased()[dealerName.startIndex])
				}
				var dealersWithLetter: [Dealer]
				if let _dealersWithLetter = dealersByLetter[dealerLetter] {
					dealersWithLetter = _dealersWithLetter
				} else {
					dealersWithLetter = []
				}
				dealersWithLetter.append(dealer)
				dealersByLetter.updateValue(dealersWithLetter, forKey: dealerLetter)
			}
		}
		sortedKeys = dealersByLetter.keys.sorted()
	}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return dealersByLetter.keys.count
	}

	override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		return sortedKeys
	}

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let letter = sortedKeys[section]
        if let dealersWithLetter = dealersByLetter[letter] {
            return (dealersWithLetter.count)
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DealersTableViewCell", for: indexPath) as! DealersTableViewCell
        cell.dealer = self.dealersByLetter[sortedKeys[(indexPath as NSIndexPath).section]]?[(indexPath as NSIndexPath).row]
        return cell
    }

    override func tableView( _ tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        return sortedKeys[section]
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		guard let header = view as? UITableViewHeaderFooterView else { return }
		header.backgroundView?.backgroundColor = UIColor.darkGray.withAlphaComponent(0.75)
		header.contentView.isOpaque = false
		header.contentView.backgroundColor = UIColor.clear
		header.textLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        header.textLabel?.textColor = UIColor.white
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "DealerTableToDetailViewSegue" {
            if let destinationVC = segue.destination as? DealerViewController, let cell = sender as? DealersTableViewCell, let dealer = cell.dealer {
                destinationVC.dealer = dealer
            }
        }
    }

}
