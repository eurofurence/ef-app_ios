//
//  KnowledgeGroupEntriesSceneFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 30/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

protocol KnowledgeGroupEntriesSceneFactory {

    func makeKnowledgeGroupEntriesScene() -> UIViewController & KnowledgeGroupEntriesScene

}
