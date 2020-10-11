import UIKit

struct Theme {

    private static let whiteTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]

    static func apply() {
        styleConventionColorViews()
        styleNavigationBars()
        styleTabBars()
        styleButtons()
        styleTableViews()
        styleTabBarItems()
        styleNavigationBarExtensions()
        styleSearchBars()
        styleTextFields()
        styleSegmentedControls()
        styleRefreshControls()
        styleImages()
        styleAwesomeFontLabels()
        styleUnreadIndicators()
    }
    
    static func performUnsafeSearchControllerStyling(searchController: UISearchController) {
        styleSearchBar(searchController.searchBar)
        
        if #available(iOS 13.0, *) {
            searchController.searchBar.searchTextField.backgroundColor = .systemBackground
            searchController.searchBar.searchTextField.layer.cornerRadius = 10
            searchController.searchBar.searchTextField.clipsToBounds = true
        } else {
            guard let backgroundview = findBackgroundFromViewHiearchy(searchBar: searchController.searchBar) else {
                return
            }
            
            backgroundview.backgroundColor = .white
            backgroundview.layer.cornerRadius = 10
            backgroundview.clipsToBounds = true
        }
    }
    
    private static func findBackgroundFromViewHiearchy(searchBar: UISearchBar) -> UIView? {
        let textfield = searchBar.value(forKey: "searchField") as? UITextField
        return textfield?.subviews.first
    }
    
    private static func styleConventionColorViews() {
        let primaryColorView = ConventionPrimaryColorView.appearance()
        primaryColorView.backgroundColor = .primary
        
        let secondaryColorView = ConventionSecondaryColorView.appearance()
        secondaryColorView.backgroundColor = .secondary
    }

    private static func styleNavigationBars() {
        let navigationBar = UINavigationBar.appearance()
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = .navigationBar
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = whiteTextAttributes
        navigationBar.setBackgroundImage(UIColor.navigationBar.makePixel(), for: .default)
        navigationBar.shadowImage = UIColor.navigationBar.makePixel()
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = .navigationBar
            appearance.titleTextAttributes = whiteTextAttributes
            appearance.largeTitleTextAttributes = whiteTextAttributes
            
            navigationBar.standardAppearance = appearance
            navigationBar.compactAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        } else {
            navigationBar.backgroundColor = .navigationBar
            navigationBar.largeTitleTextAttributes = whiteTextAttributes
        }
    }

    private static func styleTabBars() {
        let tabBar = UITabBar.appearance()
        tabBar.isTranslucent = false
        tabBar.barTintColor = .tabBar
        tabBar.tintColor = .selectedTabBarItem
        tabBar.unselectedItemTintColor = .unselectedTabBarItem
    }

    private static func styleButtons() {
        styleButtonsWithinTableViewCells()
        styleButtonsWithinNavigationBars()
        styleLargeActionButton()
    }

    private static func styleButtonsWithinTableViewCells() {
        let buttonInsideTableView = UIButton.appearance(whenContainedInInstancesOf: [UITableViewCell.self])
        buttonInsideTableView.setTitleColor(.buttons, for: .normal)
        buttonInsideTableView.setTitleColor(.conferenceGrey, for: .disabled)
        
        let buttonInsideEventCell = UIButton.appearance(whenContainedInInstancesOf: [EventTableViewCell.self])
        buttonInsideEventCell.setTitleColor(.white, for: .normal)
    }

    private static func styleButtonsWithinNavigationBars() {
        let buttonsInsideNavigationBar = UIButton.appearance(whenContainedInInstancesOf: [UINavigationBar.self])
        buttonsInsideNavigationBar.tintColor = .white
    }
    
    private static func styleLargeActionButton() {
        let appearance = RoundedCornerButton.appearance()
        appearance.backgroundColor = .largeActionButton
        appearance.tintColor = .white
    }
    
    private static func styleTableViews() {
        let tableView = UITableView.appearance()
        tableView.sectionIndexColor = .tableIndex
        tableView.sectionIndexBackgroundColor = .clear
        
        styleTableViewHeaders()
    }
    
    private static func styleTableViewHeaders() {
        let conventionTableViewHeaderLabel = UILabel.appearance(
            whenContainedInInstancesOf: [ConventionBrandedTableViewHeaderFooterView.self]
        )
        
        conventionTableViewHeaderLabel.textColor = .white
    }

    private static func styleTabBarItems() {
        let tabBarItem = UITabBarItem.appearance()
        tabBarItem.setTitleTextAttributes(whiteTextAttributes, for: .normal)
    }

    private static func styleNavigationBarExtensions() {
        let navigationBarExtension = NavigationBarViewExtensionContainer.appearance()
        navigationBarExtension.backgroundColor = .navigationBar

        styleLabelsWithinNavigationBarExtensions()
    }

    private static func styleLabelsWithinNavigationBarExtensions() {
        let labelsInsideNavigationBarExtension = UILabel.appearance(
            whenContainedInInstancesOf: [NavigationBarViewExtensionContainer.self]
        )
        
        labelsInsideNavigationBarExtension.textColor = .white
    }

    private static func styleSearchBars() {
        let searchBar = UISearchBar.appearance()
        searchBar.barTintColor = .searchBarTint
        searchBar.isTranslucent = false

        styleBarButtonItemsWithinSearchBars()
    }

    private static func styleBarButtonItemsWithinSearchBars() {
        let buttonsInsideSearchBar = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        buttonsInsideSearchBar.setTitleTextAttributes(whiteTextAttributes, for: .normal)
    }

    private static func styleTextFields() {
        let textField = UITextField.appearance()
        textField.tintColor = .tintColor
    }

    private static func styleSegmentedControls() {
        let segmentControl = UISegmentedControl.appearance()
        segmentControl.tintColor = .white
    }
    
    private static func styleRefreshControls() {
        let refreshControl = UIRefreshControl.appearance()
        refreshControl.tintColor = .refreshControl
    }
    
    private static func styleImages() {
        let image = UIImageView.appearance()
        image.tintColor = .tintColor
    }
    
    private static func styleAwesomeFontLabels() {
        let appearance = AwesomeFontLabel.appearance()
        appearance.textColor = .iconographicTint
    }
    
    private static func styleUnreadIndicators() {
        let appearance = UnreadIndicatorView.appearance()
        appearance.tintColor = .unreadIndicator
    }
    
    private static func styleSearchBar(_ searchBar: UISearchBar) {
        let dividerPixel = UIColor.segmentSeperator.makeColoredImage(size: CGSize(width: 1, height: 1))
        searchBar.setScopeBarButtonBackgroundImage(dividerPixel, for: .selected)
        searchBar.setScopeBarButtonDividerImage(dividerPixel, forLeftSegmentState: .normal, rightSegmentState: .normal)
        
        searchBar.setScopeBarButtonDividerImage(
            dividerPixel,
            forLeftSegmentState: .selected,
            rightSegmentState: .normal
        )
        
        searchBar.setScopeBarButtonDividerImage(
            dividerPixel,
            forLeftSegmentState: .normal,
            rightSegmentState: .selected
        )
        
        let selectedText = [NSAttributedString.Key.foregroundColor: UIColor.selectedSegmentText]
        let unselectedText = [NSAttributedString.Key.foregroundColor: UIColor.unselectedSegmentText]
        searchBar.setScopeBarButtonTitleTextAttributes(selectedText, for: .selected)
        searchBar.setScopeBarButtonTitleTextAttributes(unselectedText, for: .normal)
        
        let emptyBackground = makeSegmentBackground(color: .unselectedSegmentBackground)
        searchBar.setScopeBarButtonBackgroundImage(emptyBackground, for: .normal)
        
        let filledBackground = makeSegmentBackground(color: .selectedSegmentBackground)
        searchBar.setScopeBarButtonBackgroundImage(filledBackground, for: .selected)
    }
    
    private static func makeSegmentBackground(color: UIColor) -> UIImage {
        let size = CGSize(width: 10, height: 10)
        let renderer = UIGraphicsImageRenderer(size: size)
        let data = renderer.pngData { (_) in
            color.setFill()
            
            let path = UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: 3)
            path.fill()
        }
        
        guard let image = UIImage(data: data) else { fatalError() }
        
        return image
    }

}
