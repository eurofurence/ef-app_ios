import EurofurenceApplicationSession
import EurofurenceModel

struct CompositionalNewsComponentDefaultWidgetsBuilder {
    
    let services: Services
    private let builder = CompositionalNewsComponentBuilder()
    
    func buildNewsComponent() -> any NewsComponentFactory {
        addPersonalisedWidget()
        addCountdownWidget()
        addUpcomingEventsWidget()
        addRunningEventsWidget()
        addTodaysFavouriteEventsWidget()
        
        return builder.build()
    }
    
    private func addPersonalisedWidget() {
        let dataSource = YourEurofurenceDataSourceServiceAdapter(
            authenticationService: services.authentication,
            privateMessagesService: services.privateMessages
        )
        
        let viewModelFactory = YourEurofurenceWidgetViewModelFactory(dataSource: dataSource)
        let widget = MVVMWidget(viewModelFactory: viewModelFactory, viewFactory: YourEurofurenceWidgetViewFactory())
        _ = builder.with(widget)
    }
    
    private func addCountdownWidget() {
        let dataSource = ConventionCountdownDataSourceServiceAdapter(countdownService: services.conventionCountdown)
        let viewModelFactory = ConventionCountdownViewModelFactory(dataSource: dataSource)
        let widget = MVVMWidget(viewModelFactory: viewModelFactory, viewFactory: ConventionCountdownViewFactory())
        _ = builder.with(widget)
    }
    
    private func addUpcomingEventsWidget() {
        let specification = UpcomingEventSpecification(configuration: RemotelyConfiguredUpcomingEventsConfiguration())
        let upcomingEventsDataSource = makeEventsDataSource(specification)
        
        _ = builder.with(makeEventsWidget(dataSource: upcomingEventsDataSource, title: .upcomingEvents))
    }
    
    private func addRunningEventsWidget() {
        let runningEventsDataSource = makeEventsDataSource(RunningEventSpecification())
        _ = builder.with(makeEventsWidget(dataSource: runningEventsDataSource, title: .runningEvents))
    }
    
    private func addTodaysFavouriteEventsWidget() {
        let todaysFavouritesSpecification = TodaysEventsSpecification() && IsFavouriteEventSpecification()
        let todaysFavouritesDataSource = makeEventsDataSource(todaysFavouritesSpecification)
        
        _ = builder.with(makeEventsWidget(dataSource: todaysFavouritesDataSource, title: .todaysFavouriteEvents))
    }
    
    private func makeEventsDataSource<S: Specification>(
        _ specification: S
    ) -> some EventsWidgetDataSource where S.Element == Event {
        FilteredScheduleWidgetDataSource(
            repository: services.events,
            specification: specification
        )
    }
    
    private func makeEventsWidget<DataSource>(
        dataSource: DataSource,
        title: String
    ) -> some NewsWidget where DataSource: EventsWidgetDataSource {
        let viewModelFactory = EventsWidgetViewModelFactory(dataSource: dataSource, description: title)
        return MVVMWidget(viewModelFactory: viewModelFactory, viewFactory: TableViewNewsWidgetViewFactory())
    }
    
}
