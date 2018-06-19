//
//  CapturingDealerComponent.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 18/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingDealerComponent: DealerComponent {
    
    private(set) var capturedDealerTitle: String?
    func setDealerTitle(_ title: String) {
        capturedDealerTitle = title
    }
    
    private(set) var capturedDealerSubtitle: String?
    func setDealerSubtitle(_ subtitle: String?) {
        capturedDealerSubtitle = subtitle
    }
    
    private(set) var capturedDealerPNGData: Data?
    func setDealerIconPNGData(_ pngData: Data) {
        capturedDealerPNGData = pngData
    }
    
    private(set) var didShowNotPresentOnAllDaysWarning = false
    func showNotPresentOnAllDaysWarning() {
        didShowNotPresentOnAllDaysWarning = true
    }
    
    private(set) var didHideNotPresentOnAllDaysWarning = false
    func hideNotPresentOnAllDaysWarning() {
        didHideNotPresentOnAllDaysWarning = true
    }
    
    private(set) var didShowAfterDarkContentWarning = false
    func showAfterDarkContentWarning() {
        didShowAfterDarkContentWarning = true
    }
    
    private(set) var didHideAfterDarkContentWarning = false
    func hideAfterDarkContentWarning() {
        didHideAfterDarkContentWarning = true
    }
    
}
