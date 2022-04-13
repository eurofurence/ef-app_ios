import RouterCore

public struct NewsAnnouncementsWidgetViewModelFactory<
    DataSource: NewsAnnouncementsDataSource
>: NewsWidgetViewModelFactory {
    
    private let dataSource: DataSource
    private let configuration: NewsAnnouncementsConfiguration
    private let formatters: AnnouncementsWidgetFormatters
    
    public init(dataSource: DataSource, configuration: NewsAnnouncementsConfiguration) {
        self.init(dataSource: dataSource, configuration: configuration, formatters: AnnouncementsWidgetFormatters())
    }
    
    public init(
        dataSource: DataSource,
        configuration: NewsAnnouncementsConfiguration,
        formatters: AnnouncementsWidgetFormatters
    ) {
        self.dataSource = dataSource
        self.configuration = configuration
        self.formatters = formatters
    }
    
    public typealias ViewModel = DataSourceBackedNewsAnnouncementsWidgetViewModel
    
    public func makeViewModel(router: Router) -> ViewModel {
        DataSourceBackedNewsAnnouncementsWidgetViewModel(
            dataSource: dataSource,
            configuration: configuration,
            formatters: formatters,
            router: router
        )
    }
    
}
