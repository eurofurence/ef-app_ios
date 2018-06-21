//
//  DealerDetailScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 21/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol DealerDetailScene {

    func setDelegate(_ delegate: DealerDetailSceneDelegate)
    func bind(numberOfComponents: Int, using binder: DealerDetailSceneBinder)

}

protocol DealerDetailSceneDelegate {

    func dealerDetailSceneDidLoad()

}

protocol DealerDetailComponentFactory {

    associatedtype Component

    func makeDealerSummaryComponent(configureUsing block: (DealerDetailSummaryComponent) -> Void) -> Component

}

protocol DealerDetailSummaryComponent {

    func showArtistArtworkImageWithPNGData(_ data: Data)
    func setDealerTitle(_ title: String)
    func setDealerSubtitle(_ subtitle: String)
    func setDealerCategories(_ categories: String)
    func setDealerShortDescription(_ shortDescription: String)
    func setDealerWebsite(_ website: String)
    func setDealerTwitterHandle(_ twitterHandle: String)
    func setDealerTelegramHandle(_ telegramHandle: String)

}
