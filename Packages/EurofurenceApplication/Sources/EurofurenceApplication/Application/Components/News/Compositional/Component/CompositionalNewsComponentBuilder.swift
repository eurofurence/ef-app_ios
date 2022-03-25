import UIKit

public class CompositionalNewsComponentBuilder {
    
    public func build() -> NewsComponentFactory {
        return CompositionalNewsComponentFactory()
    }
    
    private struct CompositionalNewsComponentFactory: NewsComponentFactory {
        
        func makeNewsComponent(_ delegate: NewsComponentDelegate) -> UIViewController {
            return UIViewController()
        }
        
    }
    
}
