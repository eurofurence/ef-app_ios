import RouterCore

public protocol NewsWidgetViewModelFactory {
    
    associatedtype ViewModel
    
    func makeViewModel(router: Router) -> ViewModel
    
}
