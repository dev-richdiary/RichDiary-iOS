//
//  DiaryModel.swift
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

enum DiaryType {
    case expense
    case income
}

enum DiaryCategoryType {
    case food
    case car
    case culture
    case mart
    case shopping
    case life
    case house
    case hospital
    case education
    case event
    case family
    case saving
    case tax
    case pet
    case etc
    
    var description: String {
        switch self {
        case .food:
            "식비"
        case .car:
            "교통/차량"
        case .culture:
            "문화생활"
        case .mart:
            "마트/편의점"
        case .shopping:
            "패션/미용"
        case .life:
            "생활용품"
        case .house:
            "주거/통신"
        case .hospital:
            "건강"
        case .education:
            "교육"
        case .event:
            "경조사/회비"
        case .family:
            "가족"
        case .saving:
            "저축성 지출"
        case .tax:
            "세금"
        case .pet:
            "반려동물"
        case .etc:
            "기타"
        }
    }
}

final class DiaryModel {
    let date: Date
    let money: Int
    let category: DiaryCategoryType
    let payment: PaymentType
    let description: String
    let memo: String
    let type: ExpenseType
    let diaryType: DiaryType

    init(date: Date, money: Int, category: DiaryCategoryType, payment: PaymentType, description: String, memo: String, type: ExpenseType, diaryType: DiaryType) {
        self.date = date
        self.money = money
        self.category = category
        self.payment = payment
        self.description = description
        self.memo = memo
        self.type = type
        self.diaryType = diaryType
    }
}

extension DiaryModel {
    static func dummy() -> [DiaryModel] {
        return [
            DiaryModel(date: .now, money: 10000, category: .food, payment: .card, description: "테스트", memo: "테스트", type: .A, diaryType: .expense),
            DiaryModel(date: .now, money: 10000, category: .car, payment: .card, description: "테스트", memo: "테스트", type: .B, diaryType: .expense),
            DiaryModel(date: .now, money: 10000, category: .car, payment: .card, description: "테스트", memo: "테스트", type: .C, diaryType: .expense),
            DiaryModel(date: .now, money: 10000, category: .car, payment: .card, description: "테스트", memo: "테스트", type: .B, diaryType: .expense),
            DiaryModel(date: .now, money: 10000, category: .car, payment: .card, description: "테스트", memo: "테스트", type: .C, diaryType: .expense),
            DiaryModel(date: .now, money: 10000, category: .car, payment: .card, description: "테스트", memo: "테스트", type: .A, diaryType: .expense),
            DiaryModel(date: .now, money: 10000, category: .car, payment: .card, description: "테스트", memo: "테스트", type: .A, diaryType: .expense),
            DiaryModel(date: .now, money: 10000, category: .car, payment: .card, description: "테스트", memo: "테스트", type: .A, diaryType: .expense),
            DiaryModel(date: .now, money: 10000, category: .car, payment: .card, description: "테스트", memo: "테스트", type: .A, diaryType: .expense),
            DiaryModel(date: .now, money: 10000, category: .car, payment: .card, description: "테스트", memo: "테스트", type: .A, diaryType: .expense),
            DiaryModel(date: .now, money: 100000, category: .saving, payment: .pay, description: "월급", memo: "월급", type: .A, diaryType: .income)
        ]
    }
}
