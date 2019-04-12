import Foundation.NSIndexPath

protocol NewsComponentsBinder {

    func bindTitleForSection(at index: Int, scene: NewsComponentHeaderScene)
    func bindComponent<T>(at indexPath: IndexPath, using componentFactory: T) -> T.Component where T: NewsComponentFactory

}

protocol NewsComponentFactory {

    associatedtype Component

    func makeConventionCountdownComponent(configuringUsing block: (ConventionCountdownComponent) -> Void) -> Component
    func makeUserWidgetComponent(configuringUsing block: (UserWidgetComponent) -> Void) -> Component
    func makeAnnouncementComponent(configuringUsing block: (AnnouncementComponent) -> Void) -> Component
    func makeAllAnnouncementsComponent(configuringUsing block: (AllAnnouncementsComponent) -> Void) -> Component
    func makeEventComponent(configuringUsing block: (ScheduleEventComponent) -> Void) -> Component

}

protocol ConventionCountdownComponent {

    func setTimeUntilConvention(_ timeUntilConvention: String)

}

protocol UserWidgetComponent {

    func setPrompt(_ prompt: String)
    func setDetailedPrompt(_ detailedPrompt: String)
    func showHighlightedUserPrompt()
    func hideHighlightedUserPrompt()
    func showStandardUserPrompt()
    func hideStandardUserPrompt()

}

protocol AllAnnouncementsComponent {

    func showCaption(_ caption: String)

}
