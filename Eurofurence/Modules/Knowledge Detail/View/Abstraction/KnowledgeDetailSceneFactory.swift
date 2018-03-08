//
//  KnowledgeDetailSceneFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit.UIViewController

protocol KnowledgeDetailSceneFactory {

    func makeKnowledgeDetailScene() -> UIViewController & KnowledgeDetailScene

}
