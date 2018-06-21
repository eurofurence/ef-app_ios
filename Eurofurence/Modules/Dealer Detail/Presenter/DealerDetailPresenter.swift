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
            let visitor = Visitor(componentFactory)
            viewModel.describeComponent(at: index, to: visitor)

            guard let component = visitor.boundComponent else {
                fatalError("Unable to bind component for DealerDetailScene at index \(index)")
            }

            return component
        }

        private class Visitor<T>: DealerDetailViewModelVisitor where T: DealerDetailComponentFactory {

            private let componentFactory: T
            private(set) var boundComponent: T.Component?

            init(_ componentFactory: T) {
                self.componentFactory = componentFactory
            }

            func visit(_ summary: DealerDetailSummaryViewModel) {
                boundComponent = componentFactory.makeDealerSummaryComponent { (component) in
                    component.showArtistArtworkImageWithPNGData(summary.artistImagePNGData)
                    component.setDealerTitle(summary.title)
                    component.setDealerSubtitle(summary.subtitle)
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
