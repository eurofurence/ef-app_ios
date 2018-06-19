//
//  DealerComponent.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 18/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol DealerComponent {

    func setDealerTitle(_ title: String)
    func setDealerSubtitle(_ subtitle: String)
    func setDealerIconPNGData(_ pngData: Data)
    func showNotPresentOnAllDaysWarning()
    func hideNotPresentOnAllDaysWarning()
    func showAfterDarkContentWarning()
    func hideAfterDarkContentWarning()

}
