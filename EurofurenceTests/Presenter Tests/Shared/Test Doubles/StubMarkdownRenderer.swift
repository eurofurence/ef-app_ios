//
//  StubMarkdownRenderer.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 06/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import Foundation

class StubMarkdownRenderer: MarkdownRenderer {

    private var producedContents = [String: NSAttributedString]()

    func render(_ contents: String) -> NSAttributedString {
        let renderedContents = NSAttributedString.random
        producedContents[contents] = renderedContents

        return renderedContents
    }

    func stubbedContents(for contents: String) -> NSAttributedString {
        return producedContents[contents] ?? .random
    }

}
