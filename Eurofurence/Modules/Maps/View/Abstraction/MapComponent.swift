//
//  MapComponent.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol MapComponent {

    func setMapName(_ mapName: String)
    func setMapPreviewImagePNGData(_ data: Data)

}
