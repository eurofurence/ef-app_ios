import UIKit

public class Theme {
    
    public static let global = Theme()
    private let whiteTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
    
    private init() {
        
    }
    
    public func apply(to tableView: UITableView) {
        if #available(iOS 15, *) {
            tableView.fillerRowHeight = 0
            tableView.sectionHeaderTopPadding = 0
        }
    }
    
    public func apply(to searchController: UISearchController) {
        let searchBar = searchController.searchBar
        styleSearchBar(searchBar)
        
        searchBar.searchTextField.backgroundColor = .systemBackground
        searchBar.searchTextField.layer.cornerRadius = 10
        searchBar.searchTextField.clipsToBounds = true
    }

    public func apply() {
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
        styleAwesomeFontLabels()
        styleUnreadIndicators()
    }
    
    private func styleConventionColorViews() {
        let primaryColorView = ConventionPrimaryColorView.appearance()
        primaryColorView.backgroundColor = .primary
        
        let secondaryColorView = ConventionSecondaryColorView.appearance()
        secondaryColorView.backgroundColor = .secondary
    }

    private func styleNavigationBars() {
        let navigationBar = UINavigationBar.appearance()
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = .navigationBar
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = whiteTextAttributes
        navigationBar.setBackgroundImage(UIColor.navigationBar.makePixel(), for: .default)
        navigationBar.shadowImage = UIColor.navigationBar.makePixel()
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .navigationBar
        appearance.titleTextAttributes = whiteTextAttributes
        appearance.largeTitleTextAttributes = whiteTextAttributes
        
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }

    private func styleTabBars() {
        let tabBar = UITabBar.appearance()
        tabBar.isTranslucent = false
        tabBar.barTintColor = .tabBar
        tabBar.tintColor = .selectedTabBarItem
        tabBar.unselectedItemTintColor = .unselectedTabBarItem
        
        let backgroundAppearance = UITabBarAppearance()
        backgroundAppearance.backgroundColor = .tabBar
        tabBar.standardAppearance = backgroundAppearance
        
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = backgroundAppearance
        }
    }

    private func styleButtons() {
        styleButtonsWithinTableViewCells()
        styleButtonsWithinNavigationBars()
        styleLargeActionButton()
    }

    private func styleButtonsWithinTableViewCells() {
        let buttonInsideTableView = UIButton.appearance(whenContainedInInstancesOf: [UITableViewCell.self])
        buttonInsideTableView.setTitleColor(.buttons, for: .normal)
        buttonInsideTableView.setTitleColor(.disabledColor, for: .disabled)
    }

    private func styleButtonsWithinNavigationBars() {
        let buttonsInsideNavigationBar = UIButton.appearance(whenContainedInInstancesOf: [UINavigationBar.self])
        buttonsInsideNavigationBar.tintColor = .white
    }
    
    private func styleLargeActionButton() {
        let appearance = RoundedCornerButton.appearance()
        appearance.backgroundColor = .largeActionButton
        appearance.tintColor = .white
    }
    
    private func styleTableViews() {
        let tableView = UITableView.appearance()
        tableView.sectionIndexColor = .tableIndex
        tableView.sectionIndexBackgroundColor = .clear
        
        styleTableViewHeaders()
    }
    
    private func styleTableViewHeaders() {
        let conventionTableViewHeaderLabel = UILabel.appearance(
            whenContainedInInstancesOf: [ConventionBrandedTableViewHeaderFooterView.self]
        )
        
        conventionTableViewHeaderLabel.textColor = .white
    }

    private func styleTabBarItems() {
        let tabBarItem = UITabBarItem.appearance()
        tabBarItem.setTitleTextAttributes(whiteTextAttributes, for: .normal)
        
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.selectedTabBarItem
        ]
        
        tabBarItem.setTitleTextAttributes(selectedTextAttributes, for: .selected)
    }

    private func styleNavigationBarExtensions() {
        let navigationBarExtension = NavigationBarViewExtensionContainer.appearance()
        navigationBarExtension.backgroundColor = .navigationBar

        styleLabelsWithinNavigationBarExtensions()
    }

    private func styleLabelsWithinNavigationBarExtensions() {
        let labelsInsideNavigationBarExtension = UILabel.appearance(
            whenContainedInInstancesOf: [NavigationBarViewExtensionContainer.self]
        )
        
        labelsInsideNavigationBarExtension.textColor = .white
    }

    private func styleSearchBars() {
        let searchBar = UISearchBar.appearance()
        searchBar.barTintColor = .searchBarTint
        searchBar.isTranslucent = false

        styleBarButtonItemsWithinSearchBars()
    }

    private func styleBarButtonItemsWithinSearchBars() {
        let buttonsInsideSearchBar = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        buttonsInsideSearchBar.setTitleTextAttributes(whiteTextAttributes, for: .normal)
    }

    private func styleTextFields() {
        let textField = UITextField.appearance()
        textField.tintColor = .efTintColor
    }

    private func styleSegmentedControls() {
        let segmentControl = UISegmentedControl.appearance()
        segmentControl.tintColor = .white
    }
    
    private func styleRefreshControls() {
        let refreshControl = UIRefreshControl.appearance()
        refreshControl.tintColor = .refreshControl
    }
    
    private func styleAwesomeFontLabels() {
        let appearance = AwesomeFontLabel.appearance()
        appearance.textColor = .iconographicTint
    }
    
    private func styleUnreadIndicators() {
        let appearance = UnreadIndicatorView.appearance()
        appearance.tintColor = .unreadIndicator
    }
    
    private func styleSearchBar(_ searchBar: UISearchBar) {
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
    
    private func makeSegmentBackground(color: UIColor) -> UIImage {
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
