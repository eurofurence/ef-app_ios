//
//  AnnouncementComponentViewModel.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 16/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import TestUtilities

extension AnnouncementComponentViewModel: RandomValueProviding {

    public static var random: AnnouncementComponentViewModel {
        return AnnouncementComponentViewModel(title: .random, detail: .random, receivedDateTime: .random, isRead: .random)
    }

}
