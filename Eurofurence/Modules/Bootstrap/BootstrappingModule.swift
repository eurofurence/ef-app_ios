//
//  BootstrappingModule.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct BootstrappingModule {

    static func bootstrap(context: ApplicationContext, routers: Routers) {
        if context.firstTimeLaunchProviding.userHasCompletedTutorial {
            let quote = context.quoteGenerator.makeQuote()
            let splashScreen = routers.splashScreenRouter.showSplashScreen()
            splashScreen.showQuote(quote.message)
            splashScreen.showQuoteAuthor(quote.author)

        } else {
            TutorialModule.initialize(context: context, routers: routers)
        }
    }

}
