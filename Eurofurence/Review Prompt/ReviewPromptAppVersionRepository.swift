//
//  ReviewPromptAppVersionRepository.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol ReviewPromptAppVersionRepository {

    var lastPromptedAppVersion: String? { get }
    func setLastPromptedAppVersion(_ lastPromptedAppVersion: String)

}
