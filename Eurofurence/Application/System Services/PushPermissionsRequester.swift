//
//  PushPermissionsRequester.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 22/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

protocol PushPermissionsRequester {

    func requestPushPermissions(completionHandler: @escaping () -> Void)

}
