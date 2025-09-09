//
//  Date+.swift
//  RichDiary
//
//  Created by OneTen on 9/9/25.
//

import UIKit

extension Date {
    func formattedWithWeekday() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd (E)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }
}
