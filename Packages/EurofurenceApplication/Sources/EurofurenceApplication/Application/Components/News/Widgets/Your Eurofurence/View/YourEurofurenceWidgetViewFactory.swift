public struct YourEurofurenceWidgetViewFactory<T>: NewsWidgetViewFactory where T: YourEurofurenceWidgetViewModel {
    
    public typealias ViewModel = T
    public typealias View = YourEurofurenceWidgetTableViewDataSource<ViewModel>
    
    public init() {
        
    }
    
    public func makeVisualController(viewModel: ViewModel) -> View {
        YourEurofurenceWidgetTableViewDataSource(viewModel: viewModel)
    }
        
}
