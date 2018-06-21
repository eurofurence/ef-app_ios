//
//  DealerDetailPresenterTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 21/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation
import UIKit

class DealerDetailPresenterTestBuilder {
    
    struct Context {
        var producedModuleViewController: UIViewController
        var scene: CapturingDealerDetailScene
    }
    
    func build() -> Context {
        let sceneFactory = StubDealerDetailSceneFactory()
        let module = DealerDetailModuleBuilder()
            .with(sceneFactory)
            .build()
            .makeDealerDetailModule(for: .random)
        return Context(producedModuleViewController: module, scene: sceneFactory.scene)
    }
    
}
