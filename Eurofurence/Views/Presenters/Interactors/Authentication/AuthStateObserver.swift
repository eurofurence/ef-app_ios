//
//  AuthStateObserver.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

protocol AuthStateObserver {

    func userDidLogin(_ user: User)
    func userDidLogout()

}
