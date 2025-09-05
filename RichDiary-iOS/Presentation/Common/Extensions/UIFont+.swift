//
//  UIFont+.swift
//  RichDiary-iOS
//
//  Created by OneTen on 9/5/25.
//

import UIKit

enum FontWeight: String {
    case regular = "Pretendard-Regular"
    case medium = "Pretendard-Medium"
    case semiBold = "Pretendard-SemiBold"
    case bold = "Pretendard-Bold"
}

enum RichFontStyle {
    
    // head
    case heading0
    case heading1
    case heading2
    case heading3
    
    // body
    case body0
    case body1
    case body2
    case body3
    case body4
    
    // caption
    case caption1
    case caption2
    case caption3
    case caption4
    case caption5
}

extension UIFont {
    static func richFont(_ style: RichFontStyle) -> UIFont {
        switch style {
        case .heading0:
            return UIFont(name: FontWeight.semiBold.rawValue, size: 21)!
        case .heading1:
            return UIFont(name: FontWeight.semiBold.rawValue, size: 17)!
        case .heading2:
            return UIFont(name: FontWeight.regular.rawValue, size: 17)!
        case .heading3:
            return UIFont(name: FontWeight.bold.rawValue, size: 13)!
        case .body0:
            return UIFont(name: FontWeight.medium.rawValue, size: 14)!
        case .body1:
            return UIFont(name: FontWeight.medium.rawValue, size: 13)!
        case .body2:
            return UIFont(name: FontWeight.regular.rawValue, size: 13)!
        case .body3:
            return UIFont(name: FontWeight.regular.rawValue, size: 14)!
        case .body4:
            return UIFont(name: FontWeight.semiBold.rawValue, size: 15)!
        case .caption1:
            return UIFont(name: FontWeight.medium.rawValue, size: 12)!
        case .caption2:
            return UIFont(name: FontWeight.regular.rawValue, size: 12)!
        case .caption3:
            return UIFont(name: FontWeight.regular.rawValue, size: 10)!
        case .caption4:
            return UIFont(name: FontWeight.bold.rawValue, size: 10)!
        case .caption5:
            return UIFont(name: FontWeight.regular.rawValue, size: 11)!
        }
    }
}
