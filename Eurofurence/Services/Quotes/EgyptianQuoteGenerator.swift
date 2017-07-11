//
//  EgyptianQuoteGenerator.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Darwin
import Foundation

struct EgyptianQuoteGenerator: QuoteGenerator {

    func makeQuote() -> Quote {
        let quotes = [
            "If you search for the laws of harmony, you will find knowledge.",
            "The best and shortest road towards knowledge of truth is Nature.",
            "The best and shortest road towards knowledge of truth is Nature.",
            "People bring about their own undoing through their tongues.",
            "To teach one must know the nature of those whom one is teaching.",
            "In every vital activity it is the path that matters.",
            "The way of knowledge is narrow.",
            "Each truth you learn will be, for you, as new as if it had never been written.",
            "If you defy an enemy by doubting his courage you double it.",
            "The nut doesn't reveal the tree it contains.",
            "For knowledge... you should know that peace is an indispensable condition of getting it.",
            "Peace is the fruit of activity, not of sleep.",
            "One foot isn't enough to walk with.",
            "Our senses serve to affirm, not to know.",
            "All seed answer light, but the color is different.",
            "The plant reveals what is in the seed.",
            "Seek peacefully, you will find.",
            "Always watch and follow nature.",
            "Judge by cause, not by effect.",
            "Experience will show you, a Master can only point the way.",
            "There grows no wheat where there is no grain."
        ]

        let index = arc4random_uniform(UInt32(quotes.count))
        let chosenQuote = quotes[Int(index)]
        return Quote(message: chosenQuote)
    }

}
