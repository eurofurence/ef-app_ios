public protocol NewsWidgetViewModelFactory {
    
    associatedtype ViewModel
    
    func makeViewModel() -> ViewModel
    
}
