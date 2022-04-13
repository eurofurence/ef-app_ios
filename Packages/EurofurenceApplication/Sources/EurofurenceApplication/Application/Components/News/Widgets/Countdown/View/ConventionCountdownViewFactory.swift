public struct ConventionCountdownViewFactory<T>: NewsWidgetViewFactory where T: ConventionCountdownViewModel {
    
    public init() {
        
    }
    
    public typealias ViewModel = T
    public typealias View = ConventionCountdownTableViewDataSource<T>
    
    public func makeVisualController(viewModel: ViewModel) -> View {
        ConventionCountdownTableViewDataSource(viewModel: viewModel)
    }
    
}
