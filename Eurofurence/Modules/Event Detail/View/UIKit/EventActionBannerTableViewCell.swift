//
//  EventActionBannerTableViewCell.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/03/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import UIKit

class EventActionBannerTableViewCell: UITableViewCell, EventActionBannerComponent {
    
    @IBOutlet private weak var bannerActionButton: UIButton!
    
    func setActionTitle(_ title: String) {
        bannerActionButton.setTitle(title, for: .normal)
    }
    
    private var handler: (() -> Void)?
    func setSelectionHandler(_ handler: @escaping () -> Void) {
        self.handler = handler
    }
    
    @IBAction private func performBannerAction() {
        handler?()
    }
    
}
