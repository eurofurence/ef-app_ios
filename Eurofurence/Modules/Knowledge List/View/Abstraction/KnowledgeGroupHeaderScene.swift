//
//  KnowledgeGroupHeaderScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit.UIImage

protocol KnowledgeGroupHeaderScene {

    func setKnowledgeGroupTitle(_ title: String)
    func setKnowledgeGroupIcon(_ icon: UIImage)
    func setKnowledgeGroupDescription(_ groupDescription: String)

}
