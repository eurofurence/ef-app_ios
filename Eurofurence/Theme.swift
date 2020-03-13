import UIKit

struct Theme {

    private static let whiteTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
    private static let pantone330UColourImage = UIColor.pantone330U.makeColoredImage(size: CGSize(width: 1, height: 1))

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
    }
    
    static func performUnsafeSearchControllerStyling(searchController: UISearchController) {
        styleSearchBar(searchController.searchBar)
        
        if #available(iOS 13.0, *) {
            searchController.searchBar.searchTextField.backgroundColor = .white
            searchController.searchBar.searchTextField.layer.cornerRadius = 10
            searchController.searchBar.searchTextField.clipsToBounds = true
        } else {
            guard #available(iOS 11.0, *) else { return }
            
            guard let backgroundview = resolveStylableBackgroundFromPrivateViewHiearchy(searchBar: searchController.searchBar) else { return }
            
            backgroundview.backgroundColor = .white
            backgroundview.layer.cornerRadius = 10
            backgroundview.clipsToBounds = true
        }
    }
    
    private static func resolveStylableBackgroundFromPrivateViewHiearchy(searchBar: UISearchBar) -> UIView? {
        let textfield = searchBar.value(forKey: "searchField") as? UITextField
        return textfield?.subviews.first
    }
    
    private static func styleConventionColorViews() {
        let primaryColorView = ConventionPrimaryColorView.appearance()
        primaryColorView.backgroundColor = .pantone330U
        
        let secondaryColorView = ConventionSecondaryColorView.appearance()
        secondaryColorView.backgroundColor = .pantone330U_45
    }

    private static func styleNavigationBars() {
        let navigationBar = UINavigationBar.appearance()
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = .pantone330U
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = whiteTextAttributes
        navigationBar.shadowImage = pantone330UColourImage
        
        if #available(iOS 11.0, *) {
            navigationBar.prefersLargeTitles = true
            navigationBar.largeTitleTextAttributes = whiteTextAttributes
        } else {
            navigationBar.setBackgroundImage(pantone330UColourImage, for: .default)
        }
    }

    private static func styleTabBars() {
        let tabBar = UITabBar.appearance()
        tabBar.isTranslucent = false
        tabBar.barTintColor = .pantone330U
        tabBar.tintColor = .white
        tabBar.backgroundImage = pantone330UColourImage
        tabBar.shadowImage = pantone330UColourImage
        tabBar.unselectedItemTintColor = .pantone330U_45
    }

    private static func styleButtons() {
        styleButtonsWithinTableViewCells()
        styleButtonsWithinNavigationBars()
    }

    private static func styleButtonsWithinTableViewCells() {
        let buttonInsideTableView = UIButton.appearance(whenContainedInInstancesOf: [UITableViewCell.self])
        buttonInsideTableView.setTitleColor(.pantone330U, for: .normal)
        buttonInsideTableView.setTitleColor(.conferenceGrey, for: .disabled)
        
        let buttonInsideEventCell = UIButton.appearance(whenContainedInInstancesOf: [EventTableViewCell.self])
        buttonInsideEventCell.setTitleColor(.white, for: .normal)
    }

    private static func styleButtonsWithinNavigationBars() {
        let buttonsInsideNavigationBar = UIButton.appearance(whenContainedInInstancesOf: [UINavigationBar.self])
        buttonsInsideNavigationBar.tintColor = .white
    }
    
    private static func styleTableViews() {
        let tableView = UITableView.appearance()
        tableView.sectionIndexColor = .pantone330U
        tableView.sectionIndexBackgroundColor = .clear
        
        styleTableViewHeaders()
    }
    
    private static func styleTableViewHeaders() {
        let conventionTableViewHeaderLabel = UILabel.appearance(whenContainedInInstancesOf: [ConventionBrandedTableViewHeaderFooterView.self])
        conventionTableViewHeaderLabel.textColor = .white
    }

    private static func styleTabBarItems() {
        let tabBarItem = UITabBarItem.appearance()
        tabBarItem.setTitleTextAttributes(whiteTextAttributes, for: .normal)
    }

    private static func styleNavigationBarExtensions() {
        let navigationBarExtension = NavigationBarViewExtensionContainer.appearance()
        navigationBarExtension.backgroundColor = .pantone330U

        styleLabelsWithinNavigationBarExtensions()
    }

    private static func styleLabelsWithinNavigationBarExtensions() {
        let labelsInsideNavigationBarExtension = UILabel.appearance(whenContainedInInstancesOf: [NavigationBarViewExtensionContainer.self])
        labelsInsideNavigationBarExtension.textColor = .white
    }

    private static func styleSearchBars() {
        let searchBar = UISearchBar.appearance()
        searchBar.barTintColor = .pantone330U
        searchBar.isTranslucent = false

        styleBarButtonItemsWithinSearchBars()
    }

    private static func styleBarButtonItemsWithinSearchBars() {
        let buttonsInsideSearchBar = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        buttonsInsideSearchBar.setTitleTextAttributes(whiteTextAttributes, for: .normal)
    }

    private static func styleTextFields() {
        let textField = UITextField.appearance()
        textField.tintColor = .pantone330U
    }

    private static func styleSegmentedControls() {
        let segmentControl = UISegmentedControl.appearance()
        segmentControl.tintColor = .white
    }
    
    private static func styleRefreshControls() {
        let refreshControl = UIRefreshControl.appearance()
        refreshControl.tintColor = .pantone330U_13
    }
    
    private static func styleImages() {
        let image = UIImageView.appearance()
        image.tintColor = .pantone330U
    }
    
    private static func styleSearchBar(_ searchBar: UISearchBar) {
        let whitePixel = UIColor.white.makeColoredImage(size: CGSize(width: 1, height: 1))
        searchBar.setScopeBarButtonBackgroundImage(whitePixel, for: .selected)
        searchBar.setScopeBarButtonDividerImage(whitePixel, forLeftSegmentState: .normal, rightSegmentState: .normal)
        searchBar.setScopeBarButtonDividerImage(whitePixel, forLeftSegmentState: .selected, rightSegmentState: .normal)
        searchBar.setScopeBarButtonDividerImage(whitePixel, forLeftSegmentState: .normal, rightSegmentState: .selected)
        
        let pantoneTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.pantone330U]
        searchBar.setScopeBarButtonTitleTextAttributes(pantoneTextAttributes, for: .selected)
        searchBar.setScopeBarButtonTitleTextAttributes(whiteTextAttributes, for: .normal)
        
        let emptyBackground = makeSegmentBackground(color: .pantone330U_45)
        searchBar.setScopeBarButtonBackgroundImage(emptyBackground, for: .normal)
        
        let filledBackground = makeSegmentBackground(color: .white)
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
