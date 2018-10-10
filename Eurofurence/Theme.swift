//
//  Theme.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 10/10/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

struct Theme {

    static func apply() {
        let whiteTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        let pantone330UColourImage = makePantone330UShadowImage()

        let navigationBar = UINavigationBar.appearance()
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = .pantone330U
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = whiteTextAttributes
        navigationBar.setBackgroundImage(pantone330UColourImage, for: .default)
        navigationBar.shadowImage = pantone330UColourImage

        let tabBar = UITabBar.appearance()
        tabBar.isTranslucent = false
        tabBar.barTintColor = .pantone330U
        tabBar.tintColor = .white
        tabBar.backgroundImage = pantone330UColourImage
        tabBar.shadowImage = pantone330UColourImage

        let buttonInsideTableView = UIButton.appearance(whenContainedInInstancesOf: [UITableViewCell.self])
        buttonInsideTableView.setTitleColor(.pantone330U, for: .normal)

        let tableView = UITableView.appearance()
        tableView.sectionIndexColor = .pantone330U

        let tabBarItem = UITabBarItem.appearance()
        tabBarItem.setTitleTextAttributes(whiteTextAttributes, for: .normal)

        let buttonsInsideNavigationBar = UIButton.appearance(whenContainedInInstancesOf: [UINavigationBar.self])
        buttonsInsideNavigationBar.tintColor = .white

        let navigationBarExtension = NavigationBarViewExtensionContainer.appearance()
        navigationBarExtension.backgroundColor = .pantone330U

        let labelsInsideNavigationBarExtension = UILabel.appearance(whenContainedInInstancesOf: [NavigationBarViewExtensionContainer.self])
        labelsInsideNavigationBarExtension.textColor = .white

        let searchBar = UISearchBar.appearance()
        searchBar.barTintColor = .pantone330U
        searchBar.isTranslucent = false

        let textField = UITextField.appearance()
        textField.tintColor = .pantone330U

        let buttonsInsideSearchBar = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        buttonsInsideSearchBar.setTitleTextAttributes(whiteTextAttributes, for: .normal)

        let segmentControl = UISegmentedControl.appearance()
        segmentControl.tintColor = .white
    }

    private static func makePantone330UShadowImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1))
        return renderer.image { (context) in
            UIColor.pantone330U.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        }
    }

}
