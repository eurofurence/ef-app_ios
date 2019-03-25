//
//  EventActionBannerComponent.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/03/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import Foundation

protocol EventActionBannerComponent {
    
    func setActionTitle(_ title: String)
    func setSelectionHandler(_ handler: @escaping () -> Void)
    
}
