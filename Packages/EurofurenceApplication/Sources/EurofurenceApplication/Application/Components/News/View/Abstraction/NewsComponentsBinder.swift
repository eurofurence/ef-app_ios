import Foundation.NSIndexPath

public protocol NewsComponentsBinder {

    func bindTitleForSection(at index: Int, scene: NewsComponentHeaderScene)
    func bindComponent<T>(
        at indexPath: IndexPath,
        using componentFactory: T
    ) -> T.Component where T: NewsItemComponentFactory

}

public protocol NewsItemComponentFactory {

    associatedtype Component

    func makeConventionCountdownComponent(configuringUsing block: (ConventionCountdownComponent) -> Void) -> Component
    func makeUserWidgetComponent(configuringUsing block: (UserWidgetComponent) -> Void) -> Component
    func makeAnnouncementComponent(configuringUsing block: (AnnouncementItemComponent) -> Void) -> Component
    func makeAllAnnouncementsComponent(configuringUsing block: (AllAnnouncementsComponent) -> Void) -> Component
    func makeEventComponent(configuringUsing block: (ScheduleEventComponent) -> Void) -> Component

}

public protocol ConventionCountdownComponent {

    func setTimeUntilConvention(_ timeUntilConvention: String)

}

public protocol UserWidgetComponent {

    func setPrompt(_ prompt: String)
    func setDetailedPrompt(_ detailedPrompt: String)
    func showHighlightedUserPrompt()
    func hideHighlightedUserPrompt()
    func showStandardUserPrompt()
    func hideStandardUserPrompt()

}

public protocol AllAnnouncementsComponent {

    func showCaption(_ caption: String)

}
