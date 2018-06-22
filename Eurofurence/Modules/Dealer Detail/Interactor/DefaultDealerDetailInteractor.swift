//
//  DefaultDealerDetailInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 22/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

private protocol DetailViewModelComponent {

    func describe(to visitor: DealerDetailViewModelVisitor)

}

class DefaultDealerDetailInteractor: DealerDetailInteractor {

    private struct ViewModel: DealerDetailViewModel {

        struct SummaryComponent: DetailViewModelComponent {

            var summary: DealerDetailSummaryViewModel

            func describe(to visitor: DealerDetailViewModelVisitor) {
                visitor.visit(summary)
            }

        }

        private var components = [DetailViewModelComponent]()

        init(data: ExtendedDealerData) {
            let summary = DealerDetailSummaryViewModel(artistImagePNGData: data.artistImagePNGData,
                                                       title: data.preferredName,
                                                       subtitle: data.alternateName,
                                                       categories: data.categories.joined(separator: ", "),
                                                       shortDescription: data.dealerShortDescription,
                                                       website: data.websiteName,
                                                       twitterHandle: data.twitterUsername,
                                                       telegramHandle: data.telegramUsername)
            let summaryComponent = SummaryComponent(summary: summary)
            components.append(summaryComponent)
        }

        var numberOfComponents: Int {
            return 4
        }

        func describeComponent(at index: Int, to visitor: DealerDetailViewModelVisitor) {
            components[index].describe(to: visitor)
        }

        func openWebsite() {

        }

        func openTwitter() {

        }

        func openTelegram() {

        }

    }

    private let dealersService: DealersService

    convenience init() {
        self.init(dealersService: EurofurenceApplication.shared)
    }

    init(dealersService: DealersService) {
        self.dealersService = dealersService
    }

    func makeDealerDetailViewModel(for identifier: Dealer2.Identifier,
                                   completionHandler: @escaping (DealerDetailViewModel) -> Void) {
        dealersService.fetchExtendedDealerData(for: identifier) { (data) in
            completionHandler(ViewModel(data: data))
        }
    }

}
