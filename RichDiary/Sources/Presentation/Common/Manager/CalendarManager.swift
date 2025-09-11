//
//  CalendarManager.swift
//  RichDiary
//
//  Created by OneTen on 9/11/25.
//

import UIKit

struct CalendarManager {
    private let calendar: Calendar
    
    init(calendar: Calendar = .current) {
        self.calendar = calendar
    }
    
    func daysInMonth(for date: Date) -> [Date?] {
        var days: [Date?] = []
        
        let components = calendar.dateComponents([.year, .month], from: date)
        guard let firstDayOfMonth = calendar.date(from: components) else { return [] }
        
        // 이번 달 일 수
        let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth)!
        
        // 시작 요일
        let weekday = calendar.component(.weekday, from: firstDayOfMonth)
        
        // 앞쪽 빈칸
        for _ in 1..<weekday { days.append(nil) }
        
        // 날짜 추가
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth) {
                days.append(date)
            }
        }
        return days
    }
    
    func previousMonth(from date: Date) -> Date {
        return calendar.date(byAdding: .month, value: -1, to: date)!
    }
    
    func nextMonth(from date: Date) -> Date {
        return calendar.date(byAdding: .month, value: 1, to: date)!
    }
}
