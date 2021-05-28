import EventsJourney

public struct SwapToScheduleTabPresentation: SchedulePresentation {
    
    private let tabNavigator: TabNavigator
    
    public init(tabNavigator: TabNavigator) {
        self.tabNavigator = tabNavigator
    }
    
    public func showSchedule() {
        tabNavigator.moveToTab()
    }
    
}
