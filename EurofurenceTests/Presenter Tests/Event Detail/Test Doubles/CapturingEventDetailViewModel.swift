//
//  CapturingEventDetailViewModel.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 31/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class CapturingEventDetailViewModel: EventDetailViewModel {
    
    var numberOfComponents: Int { return 0}
    
    fileprivate var delegate: EventDetailViewModelDelegate?
    func setDelegate(_ delegate: EventDetailViewModelDelegate) {
        self.delegate = delegate
    }
    
    func describe(componentAt index: Int, to visitor: EventDetailViewModelVisitor) {
        
    }
    
    private(set) var wasToldToFavouriteEvent = false
    func favourite() {
        wasToldToFavouriteEvent = true
    }
    
}

extension CapturingEventDetailViewModel {
    
    func simulateFavourited() {
        delegate?.eventFavourited()
    }
    
}
