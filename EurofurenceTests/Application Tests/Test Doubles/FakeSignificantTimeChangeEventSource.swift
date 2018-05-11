//
//  FakeSignificantTimeChangeEventSource.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 11/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class FakeSignificantTimeChangeEventSource: SignificantTimeChangeEventSource {
    
    fileprivate var observers = [SignificantTimeChangeEventObserver]()
    func add(_ observer: SignificantTimeChangeEventObserver) {
        observers.append(observer)
    }
    
}

extension FakeSignificantTimeChangeEventSource {
    
    func simulateSignificantTimeChange() {
        observers.forEach({ $0.significantTimeChangeDidOccur() })
    }
    
}
