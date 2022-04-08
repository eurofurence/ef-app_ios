public struct TableViewNewsWidgetViewFactory<T>: NewsWidgetViewFactory where T: EventsWidgetViewModel {
    
    public init() {
        
    }
    
    public typealias ViewModel = T
    public typealias View = EventsNewsWidgetTableViewDataSource<T>
    
    public func makeVisualController(viewModel: ViewModel) -> View {
        EventsNewsWidgetTableViewDataSource(viewModel: viewModel)
    }
    
}
