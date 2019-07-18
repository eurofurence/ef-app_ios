import Foundation

public protocol DealerCategory {
    
    var name: String { get }
    
    func activate()
    func deactivate()
    func add(_ observer: DealerCategoryObserver)
    
}

public protocol DealerCategoryObserver {
    
    func categoryDidActivate(_ category: DealerCategory)
    func categoryDidDeactivate(_ category: DealerCategory)
    
}
