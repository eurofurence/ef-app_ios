//
//  KnowledgeGroupEntriesInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 30/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

protocol KnowledgeGroupEntriesInteractor {

    func makeViewModelForGroup(identifier: KnowledgeGroup.Identifier, completionHandler: @escaping (KnowledgeGroupEntriesViewModel) -> Void)

}
