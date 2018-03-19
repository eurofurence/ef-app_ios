//
//  SafariWebModuleProviding.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 19/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import SafariServices

struct SafariWebModuleProviding: WebModuleProviding {

    func makeWebModule(for url: URL) -> UIViewController {
        return SFSafariViewController(url: url)
    }

}
