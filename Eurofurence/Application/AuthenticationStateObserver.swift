//
//  AuthenticationStateObserver.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

protocol AuthenticationStateObserver: class {

    func loggedIn(as user: User)

}
