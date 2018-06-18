//
//  StubDealerViewModel.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 18/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

final class StubDealerViewModel: DealerViewModel {
    
    var title: String = .random
    var subtitle: String = .random
    var iconPNGData: Data? = .random
    
    func fetchIconPNGData(completionHandler: @escaping (Data?) -> Void) {
        completionHandler(iconPNGData)
    }
    
}
