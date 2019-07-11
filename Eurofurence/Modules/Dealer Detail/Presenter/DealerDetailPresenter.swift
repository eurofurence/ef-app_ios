import EurofurenceModel
import Foundation

class DealerDetailPresenter: DealerDetailSceneDelegate {

    private struct Binder: DealerDetailSceneBinder {

        var viewModel: DealerDetailViewModel

        func bindComponent<T>(at index: Int, using componentFactory: T) -> T.Component where T: DealerDetailComponentFactory {
            let visitor = BindingDealerDetailVisitor(componentFactory, viewModel: viewModel)
            viewModel.describeComponent(at: index, to: visitor)

            guard let component = visitor.boundComponent else {
                fatalError("Unable to bind component for DealerDetailScene at index \(index)")
            }

            return component
        }

    }

    class BindingDealerDetailVisitor<T>: DealerDetailViewModelVisitor where T: DealerDetailComponentFactory {

        private let componentFactory: T
        private let viewModel: DealerDetailViewModel
        private(set) var boundComponent: T.Component?

        init(_ componentFactory: T, viewModel: DealerDetailViewModel) {
            self.componentFactory = componentFactory
            self.viewModel = viewModel
        }

        func visit(_ summary: DealerDetailSummaryViewModel) {
            boundComponent = componentFactory.makeDealerSummaryComponent { (component) in
                component.setDealerTitle(summary.title)
                component.setDealerCategories(summary.categories)
                component.hideArtistArtwork()
                component.hideDealerSubtitle()
                component.hideDealerShortDescription()
                component.hideTwitterHandle()
                component.hideTelegramHandle()
                component.hideDealerWebsite()
                component.onWebsiteSelected(perform: viewModel.openWebsite)
                component.onTwitterSelected(perform: viewModel.openTwitter)
                component.onTelegramSelected(perform: viewModel.openTelegram)

                if let artworkData = summary.artistImagePNGData {
                    component.showArtistArtworkImageWithPNGData(artworkData)
                }

                if let subtitle = summary.subtitle {
                    component.showDealerSubtitle(subtitle)
                }

                if let shortDescription = summary.shortDescription {
                    component.showDealerShortDescription(shortDescription)
                }

                if let website = summary.website {
                    component.showDealerWebsite(website)
                }

                if let twitterHandle = summary.twitterHandle {
                    component.showDealerTwitterHandle(twitterHandle)
                }

                if let telegramHandle = summary.telegramHandle {
                    component.showDealerTelegramHandle(telegramHandle)
                }
            }
        }

        func visit(_ location: DealerDetailLocationAndAvailabilityViewModel) {
            boundComponent = componentFactory.makeDealerLocationAndAvailabilityComponent { (component) in
                component.setComponentTitle(location.title)
                component.hideMap()
                component.hideLimitedAvailbilityWarning()
                component.hideAfterDarkDenNotice()

                if let mapPNGGraphicData = location.mapPNGGraphicData {
                    component.showMapPNGGraphicData(mapPNGGraphicData)
                }

                if let limitedAvailabilityWarning = location.limitedAvailabilityWarning {
                    component.showDealerLimitedAvailabilityWarning(limitedAvailabilityWarning)
                }

                if let locatedInAfterDarkDealersDenMessage = location.locatedInAfterDarkDealersDenMessage {
                    component.showLocatedInAfterDarkDealersDenMessage(locatedInAfterDarkDealersDenMessage)
                }
            }
        }

        func visit(_ aboutTheArtist: DealerDetailAboutTheArtistViewModel) {
            boundComponent = componentFactory.makeAboutTheArtistComponent { (component) in
                component.setAboutTheArtistTitle(aboutTheArtist.title)
                component.setArtistDescription(aboutTheArtist.artistDescription)
            }
        }

        func visit(_ aboutTheArt: DealerDetailAboutTheArtViewModel) {
            boundComponent = componentFactory.makeAboutTheArtComponent { (component) in
                component.setComponentTitle(aboutTheArt.title)
                component.hideAboutTheArtDescription()
                component.hideArtPreviewImage()
                component.hideArtPreviewCaption()

                if let aboutTheArt = aboutTheArt.aboutTheArt {
                    component.showAboutTheArtDescription(aboutTheArt)
                }

                if let artPreviewImagePNGData = aboutTheArt.artPreviewImagePNGData {
                    component.showArtPreviewImagePNGData(artPreviewImagePNGData)
                }

                if let artPreviewCaption = aboutTheArt.artPreviewCaption {
                    component.showArtPreviewCaption(artPreviewCaption)
                }
            }
        }

    }

    private let scene: DealerDetailScene
    private let interactor: DealerDetailInteractor
    private let dealer: DealerIdentifier
    private let dealerInteractionRecorder: DealerInteractionRecorder
    private var viewModel: DealerDetailViewModel?

    init(scene: DealerDetailScene, interactor: DealerDetailInteractor, dealer: DealerIdentifier, dealerInteractionRecorder: DealerInteractionRecorder) {
        self.scene = scene
        self.interactor = interactor
        self.dealer = dealer
        self.dealerInteractionRecorder = dealerInteractionRecorder

        scene.setDelegate(self)
    }

    func dealerDetailSceneDidLoad() {
        dealerInteractionRecorder.recordInteraction(for: dealer)
        
        interactor.makeDealerDetailViewModel(for: dealer) { (viewModel) in
            self.viewModel = viewModel
            self.scene.bind(numberOfComponents: viewModel.numberOfComponents,
                            using: Binder(viewModel: viewModel))
        }
    }
    
    func dealerDetailSceneDidTapShareButton(_ sender: Any) {
        viewModel?.shareDealer(sender)
    }

}
