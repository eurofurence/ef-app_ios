//
//  UserCompletedTutorialStateProviding.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol UserCompletedTutorialStateProviding {

    var userHasCompletedTutorial: Bool { get }

    func markTutorialAsComplete()

}
