import Foundation

protocol DealerDetailScene {

    func setDelegate(_ delegate: DealerDetailSceneDelegate)
    func bind(numberOfComponents: Int, using binder: DealerDetailSceneBinder)

}

protocol DealerDetailSceneDelegate {

    func dealerDetailSceneDidLoad()
    func dealerDetailSceneDidAppear()
    func dealerDetailSceneDidDisappear()
    func dealerDetailSceneDidTapShareButton(_ sender: Any)

}

protocol DealerDetailItemComponentFactory {

    associatedtype Component

    func makeDealerSummaryComponent(configureUsing block: (DealerDetailSummaryComponent) -> Void) -> Component
    func makeDealerLocationAndAvailabilityComponent(configureUsing block: (DealerLocationAndAvailabilityComponent) -> Void) -> Component
    func makeAboutTheArtistComponent(configureUsing block: (DealerAboutTheArtistComponent) -> Void) -> Component
    func makeAboutTheArtComponent(configureUsing block: (AboutTheArtComponent) -> Void) -> Component

}

protocol DealerDetailSummaryComponent {

    func setDealerTitle(_ title: String)
    func setDealerCategories(_ categories: String)
    func showArtistArtworkImageWithPNGData(_ data: Data)
    func hideArtistArtwork()
    func showDealerSubtitle(_ subtitle: String)
    func hideDealerSubtitle()
    func showDealerShortDescription(_ shortDescription: String)
    func hideDealerShortDescription()
    func showDealerWebsite(_ website: String)
    func hideDealerWebsite()
    func showDealerTwitterHandle(_ twitterHandle: String)
    func hideTwitterHandle()
    func showDealerTelegramHandle(_ telegramHandle: String)
    func hideTelegramHandle()

    func onWebsiteSelected(perform block: @escaping () -> Void)
    func onTwitterSelected(perform block: @escaping () -> Void)
    func onTelegramSelected(perform block: @escaping () -> Void)

}

protocol DealerLocationAndAvailabilityComponent {

    func setComponentTitle(_ title: String)
    func showMapPNGGraphicData(_ data: Data)
    func showDealerLimitedAvailabilityWarning(_ warning: String)
    func showLocatedInAfterDarkDealersDenMessage(_ message: String)
    func hideMap()
    func hideLimitedAvailbilityWarning()
    func hideAfterDarkDenNotice()

}
