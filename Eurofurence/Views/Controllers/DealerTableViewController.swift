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
	let dataContext: IDataContext = try! ContextResolver.container.resolve()
	var dealersByLetter: [String: [Dealer]] = [:]
	var sortedKeys: [String] = []
	var disposable = CompositeDisposable()
		
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor =  UIColor(red: 35/255.0, green: 36/255.0, blue: 38/255.0, alpha: 1.0)
        self.refreshControl?.addTarget(self, action: #selector(DealerTableViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        self.tableView.sectionIndexColor = UIColor.white
    }
    
    func canRotate()->Bool {
        return true
	}
	
	// TODO: Pull into super class for all refreshable ViewControllers
	/// Initiates sync with API via refreshControl
	func refresh(_ sender:AnyObject) {
		guard let refreshControl = self.refreshControl else {
			return
		}
		
		let contextManager = try! ContextResolver.container.resolve() as ContextManager
		disposable += contextManager.syncWithApi?.apply(1234).observe(on: QueueScheduler.concurrent).start({ result in
			if result.isCompleted {
				print("Sync completed")
				DispatchQueue.main.async {
					refreshControl.endRefreshing()
				}
			} else if let value = result.value {
				print("Sync completed by \(value.fractionCompleted)")
			} else {
				print("Error during sync: \(String(describing: result.error))")
				DispatchQueue.main.async {
					refreshControl.endRefreshing()
				}
			}
		})
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
	
	override func viewWillAppear(_ animated: Bool) {
		if !disposable.isDisposed {
			disposable.dispose()
		}
		disposable = CompositeDisposable()
		
		disposable += dataContext.Dealers.signal
			.observe(on: QueueScheduler.concurrent).observe({ [weak self] observer in
				guard let strongSelf = self else { return }
				strongSelf.orderDealersAlphabeticaly(strongSelf.dataContext.Dealers.value)
				strongSelf.tableView.reloadData()
		})
		
		orderDealersAlphabeticaly(dataContext.Dealers.value)
		tableView.reloadData()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		disposable.dispose()
		
		super.viewWillDisappear(animated)
	}
	
    // MARK: - Table view data source
	
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dealersByLetter.keys.count
	}
	
	override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		return sortedKeys
	}
	
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let letter = sortedKeys[section];
        if let dealersWithLetter = dealersByLetter[letter] {
            return (dealersWithLetter.count)
        }
        else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DealersTableViewCell", for: indexPath) as! DealersTableViewCell
        cell.dealer = self.dealersByLetter[sortedKeys[(indexPath as NSIndexPath).section]]?[(indexPath as NSIndexPath).row]
        return cell
    }
	
    override func tableView( _ tableView : UITableView,  titleForHeaderInSection section: Int)->String {
        return sortedKeys[section]
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor(red: 68/255, green: 69/255, blue: 72/255, alpha: 1.0) //make the background color light blue
        header.textLabel!.textColor = UIColor.white //make the text white
        header.alpha = 0.8 //make the header transparent
    }
	
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "DealerTableToDetailViewSegue" {
            if let destinationVC = segue.destination as? DealerViewController{
                let indexPath = self.tableView.indexPathForSelectedRow!
                destinationVC.dealer = self.dealersByLetter[sortedKeys[(indexPath as NSIndexPath).section]]![(indexPath as NSIndexPath).row]
            }
        }
    }
    
    @IBAction func openMenu(_ sender: AnyObject) {
        if let _ = self.slideMenuController() {
            self.slideMenuController()?.openLeft()
        }
    }
	
	deinit {
		disposable.dispose()
	}
}
