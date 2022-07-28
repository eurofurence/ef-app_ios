import Foundation

public protocol EventDetailItemComponentFactory {

    associatedtype Component

    func makeEventSummaryComponent(configuringUsing block: (EventSummaryComponent) -> Void) -> Component
    func makeEventDescriptionComponent(configuringUsing block: (EventDescriptionComponent) -> Void) -> Component
    func makeEventGraphicComponent(configuringUsing block: (EventGraphicComponent) -> Void) -> Component
    func makeSponsorsOnlyBannerComponent(configuringUsing block: (EventInformationBannerComponent) -> Void) -> Component
    
    func makeSuperSponsorsOnlyBannerComponent(
        configuringUsing block: (EventInformationBannerComponent) -> Void
    ) -> Component
    
    func makeArtShowBannerComponent(configuringUsing block: (EventInformationBannerComponent) -> Void) -> Component
    func makeKageBannerComponent(configuringUsing block: (EventInformationBannerComponent) -> Void) -> Component
    func makeDealersDenBannerComponent(configuringUsing block: (EventInformationBannerComponent) -> Void) -> Component
    func makeMainStageBannerComponent(configuringUsing block: (EventInformationBannerComponent) -> Void) -> Component
    func makePhotoshootBannerComponent(configuringUsing block: (EventInformationBannerComponent) -> Void) -> Component
    func makeFaceMaskBannerComponent(configuringUsing block: (EventInformationBannerComponent) -> Void) -> Component
    func makeEventActionBannerComponent(configuringUsing block: (EventActionBannerComponent) -> Void) -> Component

}
