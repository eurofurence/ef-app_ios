//
//  MapDetailPresenterTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 27/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit

class MapDetailPresenterTestBuilder {
    
    struct Context {
        var scene: CapturingMapDetailScene
        var producedViewController: UIViewController
    }
    
    private var interactor: MapDetailInteractor
    
    init() {
        interactor = FakeMapDetailInteractor()
    }
    
    @discardableResult
    func with(_ interactor: MapDetailInteractor) -> MapDetailPresenterTestBuilder {
        self.interactor = interactor
        return self
    }
    
    func build(for identifier: Map2.Identifier = .random) -> Context {
        let sceneFactory = StubMapDetailSceneFactory()
        let module = MapDetailModuleBuilder()
            .with(sceneFactory)
            .with(interactor)
            .build()
            .makeMapDetailModule(for: identifier)
        
        return Context(scene: sceneFactory.scene, producedViewController: module)
    }
    
}

extension MapDetailPresenterTestBuilder.Context {
    
    func simulateSceneDidLoad() {
        scene.delegate?.mapDetailSceneDidLoad()
    }
    
    func simulateSceneDidDidTapMap(at location: TappedMapPosition) {
        scene.delegate?.mapDetailSceneDidTapMap(at: location)
    }
    
}
