import Eurofurence
import EurofurenceModel
import UIKit

class CapturingDealerDetailScene: UIViewController, DealerDetailScene, DealerDetailItemComponentFactory {

    private(set) var delegate: DealerDetailSceneDelegate?
    func setDelegate(_ delegate: DealerDetailSceneDelegate) {
        self.delegate = delegate
    }

    private(set) var boundNumberOfComponents: Int?
    private(set) var binder: DealerDetailSceneBinder?
    func bind(numberOfComponents: Int, using binder: DealerDetailSceneBinder) {
        boundNumberOfComponents = numberOfComponents
        self.binder = binder
    }

    typealias Component = AnyObject

    private(set) var boundDealerSummaryComponent: CapturingDealerDetailSummaryComponent?
    func makeDealerSummaryComponent(configureUsing block: (DealerDetailSummaryComponent) -> Void) -> Component {
        let component = CapturingDealerDetailSummaryComponent()
        block(component)
        boundDealerSummaryComponent = component
        return component
    }

    private(set) var boundLocationAndAvailabilityComponent: CapturingDealerLocationAndAvailabilityComponent?
    func makeDealerLocationAndAvailabilityComponent(
        configureUsing block: (DealerLocationAndAvailabilityComponent) -> Void
    ) -> Component {
        let component = CapturingDealerLocationAndAvailabilityComponent()
        block(component)
        boundLocationAndAvailabilityComponent = component
        return component
    }

    private(set) var boundAboutTheArtistComponent: CapturingAboutTheArtistComponent?
    func makeAboutTheArtistComponent(configureUsing block: (DealerAboutTheArtistComponent) -> Void) -> Component {
        let component = CapturingAboutTheArtistComponent()
        block(component)
        boundAboutTheArtistComponent = component
        return component
    }

    private(set) var boundAboutTheArtComponent: CapturingAboutTheArtComponent?
    func makeAboutTheArtComponent(configureUsing block: (AboutTheArtComponent) -> Void) -> Component {
        let component = CapturingAboutTheArtComponent()
        block(component)
        boundAboutTheArtComponent = component
        return component
    }

}

extension CapturingDealerDetailScene {

    @discardableResult
    func bindComponent(at index: Int) -> Component? {
        return binder?.bindComponent(at: index, using: self)
    }
    
    func simulateShareButtonTapped(_ sender: Any) {
        delegate?.dealerDetailSceneDidTapShareButton(sender)
    }

}

class CapturingDealerDetailSummaryComponent: DealerDetailSummaryComponent {

    private(set) var capturedOnWebsiteSelected: (() -> Void)?
    func onWebsiteSelected(perform block: @escaping () -> Void) {
        capturedOnWebsiteSelected = block
    }

    private(set) var capturedOnTwitterSelected: (() -> Void)?
    func onTwitterSelected(perform block: @escaping () -> Void) {
        capturedOnTwitterSelected = block
    }

    private(set) var capturedOnTelegramSelected: (() -> Void)?
    func onTelegramSelected(perform block: @escaping () -> Void) {
        capturedOnTelegramSelected = block
    }

    private(set) var capturedArtistImagePNGData: Data?
    func showArtistArtworkImageWithPNGData(_ data: Data) {
        capturedArtistImagePNGData = data
    }

    private(set) var didHideArtistArtwork = false
    func hideArtistArtwork() {
        didHideArtistArtwork = true
    }

    private(set) var capturedDealerTitle: String?
    func setDealerTitle(_ title: String) {
        capturedDealerTitle = title
    }

    private(set) var capturedDealerSubtitle: String?
    func showDealerSubtitle(_ subtitle: String) {
        capturedDealerSubtitle = subtitle
    }

    private(set) var didHideSubtitle = false
    func hideDealerSubtitle() {
        didHideSubtitle = true
    }

    private(set) var capturedDealerCategories: String?
    func setDealerCategories(_ categories: String) {
        capturedDealerCategories = categories
    }

    private(set) var capturedDealerShortDescription: String?
    func showDealerShortDescription(_ shortDescription: String) {
        capturedDealerShortDescription = shortDescription
    }

    private(set) var didHideShortDescription = false
    func hideDealerShortDescription() {
        didHideShortDescription = true
    }

    private(set) var capturedDealerWebsite: String?
    func showDealerWebsite(_ website: String) {
        capturedDealerWebsite = website
    }

    private(set) var didHideWebsite = false
    func hideDealerWebsite() {
        didHideWebsite = true
    }

    private(set) var capturedDealerTwitterHandle: String?
    func showDealerTwitterHandle(_ twitterHandle: String) {
        capturedDealerTwitterHandle = twitterHandle
    }

    private(set) var didHideTwitterHandle = false
    func hideTwitterHandle() {
        didHideTwitterHandle = true
    }

    private(set) var capturedDealerTelegramHandle: String?
    func showDealerTelegramHandle(_ telegramHandle: String) {
        capturedDealerTelegramHandle = telegramHandle
    }

    private(set) var didHideTelegramHandle = false
    func hideTelegramHandle() {
        didHideTelegramHandle = true
    }

}

class CapturingDealerLocationAndAvailabilityComponent: DealerLocationAndAvailabilityComponent {

    private(set) var capturedTitle: String?
    func setComponentTitle(_ title: String) {
        capturedTitle = title
    }

    private(set) var capturedMapPNGGraphicData: Data?
    func showMapPNGGraphicData(_ data: Data) {
        capturedMapPNGGraphicData = data
    }

    private(set) var capturedLimitedAvailabilityWarning: String?
    func showDealerLimitedAvailabilityWarning(_ warning: String) {
        capturedLimitedAvailabilityWarning = warning
    }

    private(set) var capturedLocatedInAfterDarkDealersDenMessage: String?
    func showLocatedInAfterDarkDealersDenMessage(_ message: String) {
        capturedLocatedInAfterDarkDealersDenMessage = message
    }

    private(set) var didHideMap = false
    func hideMap() {
        didHideMap = true
    }

    private(set) var didHideLimitedAvailbilityWarning = false
    func hideLimitedAvailbilityWarning() {
        didHideLimitedAvailbilityWarning = true
    }

    private(set) var didHideAfterDarkDenNotice = false
    func hideAfterDarkDenNotice() {
        didHideAfterDarkDenNotice = true
    }

}

class CapturingAboutTheArtistComponent: DealerAboutTheArtistComponent {

    private(set) var capturedTitle: String?
    func setAboutTheArtistTitle(_ title: String) {
        capturedTitle = title
    }

    private(set) var capturedArtistDescription: String?
    func setArtistDescription(_ artistDescription: String) {
        capturedArtistDescription = artistDescription
    }

}

class CapturingAboutTheArtComponent: AboutTheArtComponent {

    private(set) var capturedTitle: String?
    func setComponentTitle(_ title: String) {
        capturedTitle = title
    }

    private(set) var capturedAboutTheArt: String?
    func showAboutTheArtDescription(_ aboutTheArt: String) {
        capturedAboutTheArt = aboutTheArt
    }

    private(set) var didHideAboutTheArtDescription = false
    func hideAboutTheArtDescription() {
        didHideAboutTheArtDescription = true
    }

    private(set) var capturedArtPreviewImagePNGData: Data?
    func showArtPreviewImagePNGData(_ artPreviewImagePNGData: Data) {
        capturedArtPreviewImagePNGData = artPreviewImagePNGData
    }

    private(set) var didHideArtPreview = false
    func hideArtPreviewImage() {
        didHideArtPreview = true
    }

    private(set) var capturedArtPreviewCaption: String?
    func showArtPreviewCaption(_ caption: String) {
        capturedArtPreviewCaption = caption
    }

    private(set) var didHideArtPreviewCaption = false
    func hideArtPreviewCaption() {
        didHideArtPreviewCaption = true
    }

}
