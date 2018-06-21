//
//  FakeDealerDetailInteractor.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 21/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class FakeDealerDetailInteractor: DealerDetailInteractor {
    
    private(set) var capturedIdentifierForProducingViewModel: Dealer2.Identifier?
    func makeDealerDetailViewModel(for identifier: Dealer2.Identifier) {
        capturedIdentifierForProducingViewModel = identifier
    }
    
}
