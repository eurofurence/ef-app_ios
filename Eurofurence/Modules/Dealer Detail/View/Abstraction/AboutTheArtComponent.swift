//
//  AboutTheArtComponent.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 22/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol AboutTheArtComponent {

    func setComponentTitle(_ title: String)
    func showAboutTheArtDescription(_ aboutTheArt: String)
    func showArtPreviewImagePNGData(_ artPreviewImagePNGData: Data)

}
