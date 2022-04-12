import RouterCore

public struct NewsAnnouncementsWidgetViewModelFactory<
    DataSource: NewsAnnouncementsDataSource
>: NewsWidgetViewModelFactory {
    
    private let dataSource: DataSource
    private let configuration: NewsAnnouncementsConfiguration
    
    public init(dataSource: DataSource, configuration: NewsAnnouncementsConfiguration) {
        self.dataSource = dataSource
        self.configuration = configuration
    }
    
    public typealias ViewModel = DataSourceBackedNewsAnnouncementsWidgetViewModel
    
    public func makeViewModel(router: Router) -> ViewModel {
        DataSourceBackedNewsAnnouncementsWidgetViewModel(
            dataSource: dataSource,
            configuration: configuration,
            router: router
        )
    }
    
}
