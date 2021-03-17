import UIKit

public class Theme {
    
    private var searchControllerThemeApplication: ((UISearchController) -> Void)?
    
    public static let global = Theme()
    
    private init() {
        
    }
    
    public func registerSearchControllerTheme(_ handler: @escaping (UISearchController) -> Void) {
        searchControllerThemeApplication = handler
    }
    
    public func apply(to searchController: UISearchController) {
        searchControllerThemeApplication?(searchController)
    }
    
}
