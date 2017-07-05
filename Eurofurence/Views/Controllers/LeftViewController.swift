//
//  LeftViewController.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import UIKit

enum LeftMenu: Int {
    case settings = 0
    case about
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class LeftViewController: UIViewController, LeftMenuProtocol {

    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    let slideMenuStoryboard = UIStoryboard(name: "SlideMenu", bundle: nil)

    var menus = ["Settings", "About"]

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        self.tableView.registerCellClass(MenuTableViewCell.self)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func viewWillAppear(_ animated: Bool) {
		// TODO: Implement VersionProvider
        self.versionLabel.text = "Version: " /*+ ConfigManager.sharedInstance.appVersion*/
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.layoutIfNeeded()
    }

    func changeViewController(_ menu: LeftMenu) {
        let destinationViewController: UIViewController
        switch menu {
        case .settings:
            destinationViewController = makeSettingsViewController()
        case .about:
            destinationViewController = makeAboutViewController()
        }

        slideMenuController()?.changeMainViewController(destinationViewController, close: true)
    }

    private func makeAboutViewController() -> UIViewController {
        let aboutViewController = slideMenuStoryboard.instantiateViewController(withIdentifier: "AboutView") as! AboutViewController
        return UINavigationController(rootViewController: aboutViewController)
    }

    private func makeSettingsViewController() -> UIViewController {
        let settingsTableViewController = slideMenuStoryboard.instantiateViewController(withIdentifier: "SettingsTableView") as! SettingsTableViewController
        return UINavigationController(rootViewController: settingsTableViewController)
    }

}

extension LeftViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let menu = LeftMenu(rawValue: (indexPath as NSIndexPath).item) {
            switch menu {
            case .settings, .about:
                return MenuTableViewCell.height()
            }
        }
        return 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = LeftMenu(rawValue: (indexPath as NSIndexPath).item) {
            self.changeViewController(menu)
        }
    }
}

extension LeftViewController : UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let menu = LeftMenu(rawValue: (indexPath as NSIndexPath).item) {
            switch menu {
        case .settings, .about:
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuTableViewCell
                cell.setData(menus[(indexPath as NSIndexPath).row])
                return cell
            }
        }
        return UITableViewCell()
    }
}

extension LeftViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView == scrollView {

        }
    }
}
