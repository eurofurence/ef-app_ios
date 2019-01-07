//
//  StubAnnouncementDetailModuleFactory.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 04/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import UIKit.UIViewController

class StubAnnouncementDetailModuleFactory: AnnouncementDetailModuleProviding {

    let stubInterface = UIViewController()
    private(set) var capturedModel: AnnouncementIdentifier?
    func makeAnnouncementDetailModule(for announcement: AnnouncementIdentifier) -> UIViewController {
        capturedModel = announcement
        return stubInterface
    }

}
