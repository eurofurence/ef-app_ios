//
//  WikiText.swift
//  Eurofurence
//
//  Based on code ported to Swift from C# code by Luchs
//  Source: https://github.com/eurofurence/ef-app_wp/blob/master/Eurofurence.Companion/ViewModel/Converter/WikiTextToHtmlConverter.cs
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class WikiText {
    private static let _regexPreceedFirstListItemWithLineBreaks = try! NSRegularExpression(pattern: "(?<=\\n)(?<!  \\* )([^\\n]+)(\\n)((  \\* [^\\n]+\\n)+(?!  \\* ))", options: [])
    private static let _regexSucceedLastListItemWithLineBreaks = try! NSRegularExpression(pattern: "(\\n  \\*[^\\n]+\\n)(?!  \\* )", options: [])
    private static let _regexParseListItems = try! NSRegularExpression(pattern: "\n  \\* ([^\\n]*)", options: [])
    private static let _regexBoldItems = try! NSRegularExpression(pattern: "\\*\\*([^\\*]*)\\*\\*", options: [])
    private static let _regexItalics = try! NSRegularExpression(pattern: "\\*([^\\*\\n]*)\\*", options: [])

    static func transformToHtml(_ wikiText: String, style: String = "") -> String {
        if !wikiText.isEmpty {
            // Normalize line breaks
            let htmlText = NSMutableString(string: "<html>\n" + style + wikiText + "\n</html>")
            htmlText.replaceOccurrences(of: "\n\n", with: "<br>\n<br>\n", options: [], range: NSRange(location: 0, length: htmlText.length))
            htmlText.replaceOccurrences(of: "\\\\", with: "<br>", options: [], range: NSRange(location: 0, length: htmlText.length))

            //print("before <ul>:\n", htmlText, "\n\n")
            WikiText._regexPreceedFirstListItemWithLineBreaks.replaceMatches(in: htmlText, options: [], range: NSRange(location: 0, length: htmlText.length), withTemplate: "$1<br>\n<ul>$2$3")
            //print("after <ul>:\n", htmlText, "\n\n")
            WikiText._regexSucceedLastListItemWithLineBreaks.replaceMatches(in: htmlText, options: [], range: NSRange(location: 0, length: htmlText.length), withTemplate: "$1</ul>\n")
            //print("after </ul>:\n", htmlText, "\n\n")
            WikiText._regexParseListItems.replaceMatches(in: htmlText, options: [], range: NSRange(location: 0, length: htmlText.length), withTemplate: "\n<li>$1</li>")
            WikiText._regexBoldItems.replaceMatches(in: htmlText, options: [], range: NSRange(location: 0, length: htmlText.length), withTemplate: "<b>$1</b>")
            WikiText._regexItalics.replaceMatches(in: htmlText, options: [], range: NSRange(location: 0, length: htmlText.length), withTemplate: "<i>$1</i>")

            return String(htmlText)
        }

        return ""
    }

}
