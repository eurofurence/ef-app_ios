//
//  KnowledgeDetailModuleBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation
import UIKit.UIViewController

class KnowledgeDetailModuleBuilder {

    private var knowledgeDetailSceneFactory: KnowledgeDetailSceneFactory

    init() {
        struct DummyKnowledgeDetailSceneFactory: KnowledgeDetailSceneFactory {
            func makeKnowledgeDetailScene() -> UIViewController & KnowledgeDetailScene {
                class DummyKnowledgeDetailScene: UIViewController, KnowledgeDetailScene {

                }

                return DummyKnowledgeDetailScene()
            }
        }

        knowledgeDetailSceneFactory = DummyKnowledgeDetailSceneFactory()
    }

    @discardableResult
    func with(_ knowledgeDetailSceneFactory: KnowledgeDetailSceneFactory) -> KnowledgeDetailModuleBuilder {
        self.knowledgeDetailSceneFactory = knowledgeDetailSceneFactory
        return self
    }

    func build() -> KnowledgeDetailModuleProviding {
        return KnowledgeDetailModule(knowledgeDetailSceneFactory: knowledgeDetailSceneFactory)
    }

}
