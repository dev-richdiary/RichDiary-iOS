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

extension DiaryModel {
    static func dummy() -> [DiaryModel] {
        let calendar = Calendar.current
        let baseDate = Date()
        let previousMonthDate = calendar.date(byAdding: .month, value: -1, to: baseDate)!
        let previousMonthDate2 = calendar.date(byAdding: .month, value: -2, to: baseDate)!
        return [
            // Previous month entries
            DiaryModel(date: calendar.date(byAdding: .day, value: -1, to: previousMonthDate)!, money: 60000, category: .house, payment: .pay, description: "인터넷 요금 납부", memo: "8월 인터넷 사용료 결제", type: .A, diaryType: .expense),
            DiaryModel(date: calendar.date(byAdding: .day, value: -5, to: previousMonthDate)!, money: 200000, category: .saving, payment: .pay, description: "적금 이체", memo: "매월 적금 자동이체", type: .A, diaryType: .expense),
            DiaryModel(date: calendar.date(byAdding: .day, value: -10, to: previousMonthDate)!, money: 300000, category: .salary, payment: .pay, description: "월급 입금", memo: "8월 급여 입금 완료", type: .A, diaryType: .income),
            DiaryModel(date: calendar.date(byAdding: .day, value: -3, to: previousMonthDate)!, money: 40000, category: .education, payment: .card, description: "서적 구매", memo: "개발 서적 구매", type: .B, diaryType: .expense),
            DiaryModel(date: calendar.date(byAdding: .day, value: -7, to: previousMonthDate)!, money: 15000, category: .food, payment: .money, description: "점심 식사", memo: "회사 근처 분식집", type: .B, diaryType: .expense),
            DiaryModel(date: calendar.date(byAdding: .day, value: -1, to: previousMonthDate2)!, money: 60000, category: .house, payment: .pay, description: "인터넷 요금 납부", memo: "7월 인터넷 사용료 결제", type: .A, diaryType: .expense),
            DiaryModel(date: calendar.date(byAdding: .day, value: -5, to: previousMonthDate2)!, money: 200000, category: .saving, payment: .pay, description: "적금 이체", memo: "매월 적금 자동이체", type: .A, diaryType: .expense),
            DiaryModel(date: calendar.date(byAdding: .day, value: -10, to: previousMonthDate2)!, money: 300000, category: .salary, payment: .pay, description: "월급 입금", memo: "7월 급여 입금 완료", type: .A, diaryType: .income),
            DiaryModel(date: calendar.date(byAdding: .day, value: -3, to: previousMonthDate2)!, money: 40000, category: .education, payment: .card, description: "서적 구매", memo: "개발 서적 구매", type: .B, diaryType: .expense),
            DiaryModel(date: calendar.date(byAdding: .day, value: -7, to: previousMonthDate2)!, money: 15000, category: .food, payment: .money, description: "점심 식사", memo: "회사 근처 분식집", type: .B, diaryType: .expense),
            
            // Current month entries
            DiaryModel(date: calendar.date(byAdding: .day, value: 0, to: baseDate)!, money: 45000, category: .food, payment: .card, description: "점심 식사", memo: "회사 근처 김밥천국에서 점심", type: .B, diaryType: .expense),
            DiaryModel(date: calendar.date(byAdding: .day, value: 0, to: baseDate)!, money: 45000, category: .food, payment: .card, description: "점심 식사", memo: "회사 근처 김밥천국에서 점심", type: .B, diaryType: .expense),
            DiaryModel(date: calendar.date(byAdding: .day, value: 0, to: baseDate)!, money: 45000, category: .food, payment: .card, description: "점심 식사", memo: "회사 근처 김밥천국에서 점심", type: .B, diaryType: .expense),
            DiaryModel(date: calendar.date(byAdding: .day, value: 0, to: baseDate)!, money: 45000, category: .food, payment: .card, description: "점심 식사", memo: "회사 근처 김밥천국에서 점심", type: .B, diaryType: .expense),
            DiaryModel(date: calendar.date(byAdding: .day, value: 0, to: baseDate)!, money: 45000, category: .food, payment: .card, description: "점심 식사", memo: "회사 근처 김밥천국에서 점심", type: .B, diaryType: .expense),
            DiaryModel(date: calendar.date(byAdding: .day, value: -1, to: baseDate)!, money: 120000, category: .car, payment: .money, description: "주유비", memo: "차량 주유소에서 휘발유 충전", type: .A, diaryType: .expense),
            DiaryModel(date: calendar.date(byAdding: .day, value: -2, to: baseDate)!, money: 30000, category: .culture, payment: .card, description: "영화 관람", memo: "주말에 친구와 영화관람", type: .C, diaryType: .expense),
            DiaryModel(date: calendar.date(byAdding: .day, value: -3, to: baseDate)!, money: 15000, category: .mart, payment: .money, description: "마트 장보기", memo: "간단한 간식과 음료 구매", type: .B, diaryType: .expense),
            DiaryModel(date: calendar.date(byAdding: .day, value: -4, to: baseDate)!, money: 50000, category: .shopping, payment: .card, description: "옷 구매", memo: "봄맞이 셔츠 구매", type: .B, diaryType: .expense),
            DiaryModel(date: calendar.date(byAdding: .day, value: -5, to: baseDate)!, money: 7000, category: .life, payment: .card, description: "생활용품 구매", memo: "세제와 화장지 구입", type: .A, diaryType: .expense),
            DiaryModel(date: calendar.date(byAdding: .day, value: -6, to: baseDate)!, money: 250000, category: .salary, payment: .pay, description: "월급 입금", memo: "이번 달 급여 입금 완료", type: .A, diaryType: .income),
            DiaryModel(date: calendar.date(byAdding: .day, value: -7, to: baseDate)!, money: 80000, category: .education, payment: .pay, description: "온라인 강의 결제", memo: "개발 관련 온라인 강의 수강료", type: .B, diaryType: .expense),
            DiaryModel(date: calendar.date(byAdding: .day, value: -8, to: baseDate)!, money: 100000, category: .event, payment: .money, description: "친구 결혼식 축의금", memo: "친구 결혼식 참석 축의금", type: .A, diaryType: .expense),
            DiaryModel(date: calendar.date(byAdding: .day, value: -9, to: baseDate)!, money: 50000, category: .pet, payment: .card, description: "반려동물 사료 구매", memo: "강아지 사료와 간식 구입", type: .A, diaryType: .expense)
        ]
    }
}
