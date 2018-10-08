//
//  SignificantTimeChangeEventSource.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 11/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public protocol SignificantTimeChangeEventSource {

    func add(_ observer: SignificantTimeChangeEventObserver)

}

public protocol SignificantTimeChangeEventObserver {

    func significantTimeChangeDidOccur()

}
