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

        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.isTranslucent = false
        navigationBarAppearance.barTintColor = .pantone330U
        navigationBarAppearance.tintColor = .white
        navigationBarAppearance.titleTextAttributes = whiteTextAttributes
        navigationBarAppearance.setBackgroundImage(pantone330UColourImage, for: .default)
        navigationBarAppearance.shadowImage = pantone330UColourImage

        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.isTranslucent = false
        tabBarAppearance.barTintColor = .pantone330U
        tabBarAppearance.tintColor = .white
        tabBarAppearance.backgroundImage = pantone330UColourImage
        tabBarAppearance.shadowImage = pantone330UColourImage

        let buttonInsideTableView = UIButton.appearance(whenContainedInInstancesOf: [UITableViewCell.self])
        buttonInsideTableView.setTitleColor(.pantone330U, for: .normal)

        let tableViewProxy = UITableView.appearance()
        tableViewProxy.sectionIndexColor = .pantone330U

        let tabBarItemAppearance = UITabBarItem.appearance()
        tabBarItemAppearance.setTitleTextAttributes(whiteTextAttributes, for: .normal)

        let buttonsInsideNavigationBarAppearance = UIButton.appearance(whenContainedInInstancesOf: [UINavigationBar.self])
        buttonsInsideNavigationBarAppearance.tintColor = .white

        let navigationBarExtensionAppearance = NavigationBarViewExtensionContainer.appearance()
        navigationBarExtensionAppearance.backgroundColor = .pantone330U

        let labelsInsideNavigationBarExtensionAppearance = UILabel.appearance(whenContainedInInstancesOf: [NavigationBarViewExtensionContainer.self])
        labelsInsideNavigationBarExtensionAppearance.textColor = .white

        let searchBarAppearance = UISearchBar.appearance()
        searchBarAppearance.barTintColor = .pantone330U
        searchBarAppearance.isTranslucent = false

        let textFieldAppearance = UITextField.appearance()
        textFieldAppearance.tintColor = .pantone330U

        let buttonsInsideSearchBarAppearance = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        buttonsInsideSearchBarAppearance.setTitleTextAttributes(whiteTextAttributes, for: .normal)

        let segmentControlAppearance = UISegmentedControl.appearance()
        segmentControlAppearance.tintColor = .white
    }

    private static func makePantone330UShadowImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1))
        return renderer.image { (context) in
            UIColor.pantone330U.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        }
    }

}
