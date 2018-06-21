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
        var interactor: FakeDealerDetailInteractor
    }
    
    func build(for identifier: Dealer2.Identifier = .random) -> Context {
        let sceneFactory = StubDealerDetailSceneFactory()
        let interactor = FakeDealerDetailInteractor()
        let module = DealerDetailModuleBuilder()
            .with(sceneFactory)
            .with(interactor)
            .build()
            .makeDealerDetailModule(for: identifier)
        
        return Context(producedModuleViewController: module,
                       scene: sceneFactory.scene,
                       interactor: interactor)
    }
    
}

extension DealerDetailPresenterTestBuilder.Context {
    
    func simulateSceneDidLoad() {
        scene.delegate?.dealerDetailSceneDidLoad()
    }
    
}
