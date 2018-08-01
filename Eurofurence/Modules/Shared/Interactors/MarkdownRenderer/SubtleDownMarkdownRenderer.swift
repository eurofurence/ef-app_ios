//
//  AnnouncementsDownMarkdownRenderer.swift
//  Eurofurence
//
//  Created by Dominik Schöner on 26/07/18.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation
import Down

struct SubtleDownMarkdownRenderer: DownMarkdownRenderer {
	let stylesheet: String? =  "* { font: -apple-system-caption2; color: #7f7f7f; } strong { font-weight: bold; } em { font-style: italic; }"
}
