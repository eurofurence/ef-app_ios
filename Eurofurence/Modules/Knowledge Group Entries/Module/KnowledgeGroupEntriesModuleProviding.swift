//
//  KnowledgeGroupEntriesModuleProviding.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 30/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation
import UIKit

protocol KnowledgeGroupEntriesModuleProviding {

    func makeKnowledgeGroupEntriesModule(_ groupIdentifier: KnowledgeGroup2.Identifier, delegate: KnowledgeGroupEntriesModuleDelegate) -> UIViewController

}
