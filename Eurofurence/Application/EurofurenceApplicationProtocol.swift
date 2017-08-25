//
//  EurofurenceApplicationProtocol.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

protocol EurofurenceApplicationProtocol {

    func retrieveCurrentUser(completionHandler: @escaping (User?) -> Void)

}
