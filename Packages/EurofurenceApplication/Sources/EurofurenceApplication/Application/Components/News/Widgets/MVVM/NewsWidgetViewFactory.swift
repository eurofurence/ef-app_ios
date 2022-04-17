public protocol NewsWidgetViewFactory {
    
    associatedtype ViewModel
    associatedtype View: TableViewMediator
    
    func makeView(viewModel: ViewModel) -> View
    
}
