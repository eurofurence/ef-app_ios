//
//  KnowledgeDetailViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class KnowledgeDetailViewController: UIViewController, KnowledgeDetailScene {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var knowledgeEntryContentsTextView: UITextView!
    
    // MARK: KnowledgeDetailScene

    func setKnowledgeDetailSceneDelegate(_ delegate: KnowledgeDetailSceneDelegate) {

    }

    func setKnowledgeDetailTitle(_ title: String) {
        super.title = title
    }

    func setAttributedKnowledgeEntryContents(_ contents: NSAttributedString) {
        knowledgeEntryContentsTextView.attributedText = contents
    }

}
