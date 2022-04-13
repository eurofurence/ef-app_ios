public protocol NewsWidgetViewFactory {
    
    associatedtype ViewModel
    associatedtype View: TableViewMediator
    
    func makeVisualController(viewModel: ViewModel) -> View
    
}
