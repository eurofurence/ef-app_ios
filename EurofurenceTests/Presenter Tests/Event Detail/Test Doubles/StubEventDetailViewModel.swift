//
//  StubEventDetailViewModel.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

struct StubEventDetailViewModel: EventDetailViewModel {
    
    var title: String = .random
    var eventStartTime: String = .random
    var location: String = .random
    var trackName: String = .random
    
}
