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

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.knowledgeDetailSceneDidLoad()
    }

    // MARK: KnowledgeDetailScene

    private var delegate: KnowledgeDetailSceneDelegate?
    func setKnowledgeDetailSceneDelegate(_ delegate: KnowledgeDetailSceneDelegate) {
        self.delegate = delegate
    }

    func setKnowledgeDetailTitle(_ title: String) {
        super.title = title
    }

    func setAttributedKnowledgeEntryContents(_ contents: NSAttributedString) {
        knowledgeEntryContentsTextView.attributedText = contents
    }

}
