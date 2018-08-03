//
//  DefaultDownMarkdownRenderer.swift
//  Eurofurence
//
//  Created by Fenrikur Sionnar on 01.08.18.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct DefaultDownMarkdownRenderer: DownMarkdownRenderer {
	let stylesheet: String? = "* { font: -apple-system-body; } strong { font-weight: bold; } em { font-style: italic; }"
}
