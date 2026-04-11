//
//  DiaryModel.swift
//  RichDiary
//
//  Created by OneTen on 9/9/25.
//

import Foundation

import RealmSwift

enum ExpenseType: String, CaseIterable {
    case A = "A", B = "B", C = "C"
    
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

enum PaymentType: String, CaseIterable {
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

enum DiaryType: String {
    case expense
    case income
}

enum DiaryCategoryType: String, CaseIterable {
    case food
    case salary
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
        case .food: return "식비"
        case .salary: return "월급"
        case .car: return "교통/차량"
        case .culture: return "문화생활"
        case .mart: return "마트/편의점"
        case .shopping: return "패션/미용"
        case .life: return "생활용품"
        case .house: return "주거/통신"
        case .hospital: return "건강"
        case .education: return "교육"
        case .event: return "경조사/회비"
        case .family: return "가족"
        case .saving: return "저축성 지출"
        case .tax: return "세금"
        case .pet: return "반려동물"
        case .etc: return "기타"
        }
    }
}

final class DiaryModel: Object {
    @Persisted(primaryKey: true) var diaryID: ObjectId
    @Persisted var date: Date
    @Persisted var money: Int
    @Persisted var diaryDescription: String
    @Persisted var memo: String
    
    @Persisted private var _category: String
    @Persisted private var _payment: String
    @Persisted private var _type: String
    @Persisted private var _diaryType: String
    
    var category: DiaryCategoryType {
        get { DiaryCategoryType(rawValue: _category) ?? .etc }
        set { _category = newValue.rawValue }
    }
    
    var payment: PaymentType {
        get { PaymentType(rawValue: _payment) ?? .card }
        set { _payment = newValue.rawValue }
    }
    
    var type: ExpenseType {
        get { ExpenseType(rawValue: _type) ?? .B }
        set { _type = newValue.rawValue }
    }
    
    var diaryType: DiaryType {
        get { DiaryType(rawValue: _diaryType) ?? .expense }
        set { _diaryType = newValue.rawValue }
    }
    
    convenience init(date: Date, money: Int, category: DiaryCategoryType, payment: PaymentType, description: String, memo: String, type: ExpenseType, diaryType: DiaryType) {
        self.init()
        self.date = date
        self.money = money
        self.category = category
        self.payment = payment
        self.diaryDescription = description
        self.memo = memo
        self.type = type
        self.diaryType = diaryType
    }
}
