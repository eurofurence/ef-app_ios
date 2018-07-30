//
//  KnowledgeEntryDetailViewModel.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol KnowledgeEntryDetailViewModel {

    var title: String { get }
    var contents: NSAttributedString { get }
    var links: [LinkViewModel] { get }

    func link(at index: Int) -> Link

}
