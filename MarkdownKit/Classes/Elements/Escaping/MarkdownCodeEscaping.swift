//
//  MarkdownCodeEscaping.swift
//  Pods
//
//  Created by Ivan Bruel on 18/07/16.
//
//

import UIKit

open class MarkdownCodeEscaping: MarkdownElement {

  fileprivate static let regex = "(?<!\\\\)(?:\\\\\\\\)*+(`+)(.*?[^`].*?)(\\1)(?!`)"

  open var regex: String {
    return MarkdownCodeEscaping.regex
  }

  open func regularExpression() throws -> NSRegularExpression {
    return try NSRegularExpression(pattern: regex, options: .dotMatchesLineSeparators)
  }

  open func match(_ match: NSTextCheckingResult, attributedString: NSMutableAttributedString) {
    let range = match.range(at: 2)
    // escaping all characters
    let matchString = attributedString.attributedSubstring(from: range).string
    let escapedString = Array<UInt16>(matchString.utf16)
      .map { (value: UInt16) -> String in String(format: "%04x", value) }
      .reduce("") { (string: String, character: String) -> String in
        return "\(string)\(character)"
    }
    attributedString.replaceCharacters(in: range, with: escapedString)
  }

}
