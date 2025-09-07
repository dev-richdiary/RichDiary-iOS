//
//  Int+.swift
//  RichDiary
//
//  Created by OneTen on 9/7/25.
//

import UIKit

extension Int {
    // 금액 형태로 변환
    var asCurrencyString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)).map { "\($0)원" } ?? "\(self)원"
    }
}
