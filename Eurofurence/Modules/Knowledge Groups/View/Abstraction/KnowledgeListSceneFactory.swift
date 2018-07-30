//
//  KnowledgeListSceneFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/01/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit.UIViewController

protocol KnowledgeListSceneFactory {

    func makeKnowledgeListScene() -> UIViewController & KnowledgeListScene

}
