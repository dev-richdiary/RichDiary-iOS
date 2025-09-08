//
//  ExpenseDiaryModel.swift
//  RichDiary
//
//  Created by OneTen on 9/9/25.
//

import Foundation

enum ExpenseType {
    case A
    case B
    case C
    
    var description: String {
        switch self {
        case .A:
            return "필수"
        case .B:
            return "선택"
        case .C:
            return "불필요"
        }
    }
}

enum PaymentType {
    case money
    case card
    case pay
    
    var description: String {
        switch self {
        case .money:
            return "현금"
        case .card:
            return "카드"
        case .pay:
            return "계좌이체/페이류"
        }
    }
}

final class ExpenseDiaryModel {
    let date: Date
    let money: Int
    let category: String
    let payment: PaymentType
    let description: String
    let memo: String
    let type: ExpenseType

    init(date: Date, money: Int, category: String, payment: PaymentType, description: String, memo: String, type: ExpenseType) {
        self.date = date
        self.money = money
        self.category = category
        self.payment = payment
        self.description = description
        self.memo = memo
        self.type = type
    }
}
