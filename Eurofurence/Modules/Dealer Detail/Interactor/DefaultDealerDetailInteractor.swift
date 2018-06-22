//
//  DefaultDealerDetailInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 22/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class DefaultDealerDetailInteractor: DealerDetailInteractor {

    private struct ViewModel: DealerDetailViewModel {

        var numberOfComponents: Int {
            return 4
        }

        func describeComponent(at index: Int, to visitor: DealerDetailViewModelVisitor) {

        }

        func openWebsite() {

        }

        func openTwitter() {

        }

        func openTelegram() {

        }

    }

    func makeDealerDetailViewModel(for identifier: Dealer2.Identifier,
                                   completionHandler: @escaping (DealerDetailViewModel) -> Void) {
        completionHandler(ViewModel())
    }

}
