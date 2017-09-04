//
//  ResolveUserAuthenticationAction.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

protocol ResolveUserAuthenticationAction {

    func run(completionHandler: @escaping (Bool) -> Void)

}
