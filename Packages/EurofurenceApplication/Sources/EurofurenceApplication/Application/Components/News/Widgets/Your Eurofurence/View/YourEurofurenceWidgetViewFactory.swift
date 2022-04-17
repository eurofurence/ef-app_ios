public struct YourEurofurenceWidgetViewFactory<T>: NewsWidgetViewFactory where T: YourEurofurenceWidgetViewModel {
    
    public typealias ViewModel = T
    public typealias View = YourEurofurenceWidgetTableViewDataSource<ViewModel>
    
    public init() {
        
    }
    
    public func makeView(viewModel: ViewModel) -> View {
        YourEurofurenceWidgetTableViewDataSource(viewModel: viewModel)
    }
        
}
