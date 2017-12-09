//
//  AuthenticationStateObserver.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

protocol AuthenticationStateObserver {

    func userDidLogin(_ user: User)
    func userDidLogout()

}
