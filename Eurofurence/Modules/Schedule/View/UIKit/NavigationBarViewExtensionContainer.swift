//
//  NavigationBarViewExtensionContainer.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class NavigationBarViewExtensionContainer: UIView {

    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        applyHairlineBorderUnderneathViewToSimulateNavigationBarBase()
    }

    private func applyHairlineBorderUnderneathViewToSimulateNavigationBarBase() {
        layer.shadowOffset = CGSize(width: 0, height: CGFloat(1) / UIScreen.main.scale)
        layer.shadowRadius = 0
        layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        layer.shadowOpacity = 0.25
    }

}
