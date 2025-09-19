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
            return standard.integer(forKey: monthlyGoalKey) 
        }
        set {
            standard.set(newValue, forKey: monthlyGoalKey)
        }
    }
}
