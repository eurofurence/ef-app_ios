import UIKit

struct Theme {

    private static let whiteTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
    private static let pantone330UColourImage = makePantone330UShadowImage()

    static func apply() {
        styleSecondaryColorView()
        styleNavigationBars()
        styleTabBars()
        styleButtons()
        styleTableViews()
        styleTabBarItems()
        styleNavigationBarExtensions()
        styleSearchBars()
        styleTextFields()
        styleSegmentedControls()
    }
    
    private static func styleSecondaryColorView() {
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
    }

    private static func styleButtonsWithinNavigationBars() {
        let buttonsInsideNavigationBar = UIButton.appearance(whenContainedInInstancesOf: [UINavigationBar.self])
        buttonsInsideNavigationBar.tintColor = .white
    }
    
    private static func styleTableViews() {
        let tableView = UITableView.appearance()
        tableView.sectionIndexColor = .pantone330U
        
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

    private static func makePantone330UShadowImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1))
        return renderer.image { (context) in
            UIColor.pantone330U.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        }
    }

}
