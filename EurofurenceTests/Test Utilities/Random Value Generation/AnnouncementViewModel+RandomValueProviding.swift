//
//  AnnouncementViewModel+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 04/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import RandomDataGeneration

extension AnnouncementViewModel: RandomValueProviding {

    public static var random: AnnouncementViewModel {
        return AnnouncementViewModel(heading: .random, contents: .random, imagePNGData: .random)
    }

}
