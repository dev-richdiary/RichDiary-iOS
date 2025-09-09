//
//  Date+.swift
//  RichDiary
//
//  Created by OneTen on 9/9/25.
//

import Foundation

extension Date {
    private static let weekdayFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd (E)"
        df.locale = Locale(identifier: "ko_KR")
        return df
    }()
    
    func formattedWithWeekday() -> String {
        Date.weekdayFormatter.string(from: self)
    }
}
