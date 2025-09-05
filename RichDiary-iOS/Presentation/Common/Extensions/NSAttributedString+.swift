//
//  NSAttributedString+.swift
//  RichDiary-iOS
//
//  Created by OneTen on 9/5/25.
//

import UIKit

extension NSAttributedString {
    static func richStyle(_ text: String, style: RichFontStyle) -> NSAttributedString {
        let font = UIFont.richFont(style)
        let letterSpacing = font.pointSize * -0.002 // -0.2%
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .kern: letterSpacing
        ]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

// 사용예시: label.attributedText = NSAttributedString.richStyle("부자가계부", style: .heading1)
