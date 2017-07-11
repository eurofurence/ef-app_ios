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

    private static let quotes = [
        quote("If you search for the laws of harmony, you will find knowledge."),
        quote("The best and shortest road towards knowledge of truth is Nature."),
        quote("The best and shortest road towards knowledge of truth is Nature."),
        quote("People bring about their own undoing through their tongues."),
        quote("To teach one must know the nature of those whom one is teaching."),
        quote("In every vital activity it is the path that matters."),
        quote("The way of knowledge is narrow."),
        quote("Each truth you learn will be, for you, as new as if it had never been written."),
        quote("If you defy an enemy by doubting his courage you double it."),
        quote("The nut doesn't reveal the tree it contains."),
        quote("For knowledge... you should know that peace is an indispensable condition of getting it."),
        quote("Peace is the fruit of activity, not of sleep."),
        quote("One foot isn't enough to walk with."),
        quote("Our senses serve to affirm, not to know."),
        quote("All seed answer light, but the color is different."),
        quote("The plant reveals what is in the seed."),
        quote("Seek peacefully, you will find."),
        quote("Always watch and follow nature."),
        quote("Judge by cause, not by effect."),
        quote("Experience will show you, a Master can only point the way."),
        quote("There grows no wheat where there is no grain.")
    ]

    private static func quote(_ message: String) -> Quote {
        return Quote(author: "Egyptian Proverb", message: message)
    }

    func makeQuote() -> Quote {
        let allQuotes = EgyptianQuoteGenerator.quotes
        let index = arc4random_uniform(UInt32(allQuotes.count))
        return allQuotes[Int(index)]
    }

}
