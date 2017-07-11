//
//  CapturingQuoteGenerator.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 11/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingQuoteGenerator: QuoteGenerator {

    var quoteToMake = Quote(author: "", message: "")
    private(set) var toldToMakeQuote = false
    func makeQuote() -> Quote {
        toldToMakeQuote = true
        return quoteToMake
    }
    
}
