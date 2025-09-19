//
//  UserDefaults+.swift
//  RichDiary
//
//  Created by OneTen on 9/19/25.
//

import Foundation

extension UserDefaults {
    static let monthlyGoalKey = "MonthlyGoalKey"
    
    static var monthlyGoal: Int {
        get {
            // 기본값은 200만원 (2_000_000)
            return standard.integer(forKey: monthlyGoalKey) == 0 ? 2_000_000 : standard.integer(forKey: monthlyGoalKey)
        }
        set {
            standard.set(newValue, forKey: monthlyGoalKey)
        }
    }
}
