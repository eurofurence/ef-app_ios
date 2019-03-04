//
//  DefaultDownMarkdownRenderer.swift
//  Eurofurence
//
//  Created by Fenrikur Sionnar on 01.08.18.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct DefaultDownMarkdownRenderer: DownMarkdownRenderer {

    // TODO: Use Swift's """ format for making this a pretty stylesheet.
    // swiftlint:disable line_length
	let stylesheet: String? = "* { font: -apple-system-body; } h1, h2, h3, h4, h5, h6, strong { font-weight: bold; } em { font-style: italic; } h1 { font-size: 175%; } h2 { font-size: 150%; } h3 { font-size: 130%; } h4 { font-size: 115%; } h5 { font-style: italic; }"

}
