public struct AnnouncementsNewsWidgetViewFactory<T: NewsAnnouncementsWidgetViewModel>: NewsWidgetViewFactory {
    
    public typealias ViewModel = T
    public typealias View = AnnouncementsNewsWidgetTableViewDataSource<T>
    
    public init() {
        
    }
    
    public func makeView(viewModel: ViewModel) -> View {
        AnnouncementsNewsWidgetTableViewDataSource(viewModel: viewModel)
    }
    
}
