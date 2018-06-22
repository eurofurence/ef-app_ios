//
//  DealerDetailPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 21/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct DealerDetailPresenter: DealerDetailSceneDelegate {

    private struct Binder: DealerDetailSceneBinder {

        var viewModel: DealerDetailViewModel

        func bindComponent<T>(at index: Int, using componentFactory: T) -> T.Component where T: DealerDetailComponentFactory {
            let visitor = Visitor(componentFactory, viewModel: viewModel)
            viewModel.describeComponent(at: index, to: visitor)

            guard let component = visitor.boundComponent else {
                fatalError("Unable to bind component for DealerDetailScene at index \(index)")
            }

            return component
        }

        private class Visitor<T>: DealerDetailViewModelVisitor where T: DealerDetailComponentFactory {

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
                    component.showMapPNGGraphicData(location.mapPNGGraphicData)
                }
            }

        }

    }

    private let scene: DealerDetailScene
    private let interactor: DealerDetailInteractor
    private let dealer: Dealer2.Identifier

    init(scene: DealerDetailScene, interactor: DealerDetailInteractor, dealer: Dealer2.Identifier) {
        self.scene = scene
        self.interactor = interactor
        self.dealer = dealer

        scene.setDelegate(self)
    }

    func dealerDetailSceneDidLoad() {
        interactor.makeDealerDetailViewModel(for: dealer) { (viewModel) in
            self.scene.bind(numberOfComponents: viewModel.numberOfComponents,
                            using: Binder(viewModel: viewModel))
        }
    }

}
