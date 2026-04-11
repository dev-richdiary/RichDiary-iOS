import Testing
import Foundation
import RealmSwift
@testable import RichDiary

/**
 # DiaryModel 명세서 (Domain Logic)
 가계부의 핵심 데이터 모델인 `DiaryModel`의 초기화, 타입 매핑 및 데이터 무결성을 검증합니다.
 */
@Suite("DiaryModel Logic Specification")
struct DiaryModelTests {
    
    // MARK: - 초기화 및 필드 매핑 검증 (동치 분할)
    
    @Test("다이어리 타입별(지출/수입) 초기화 무결성 확인", arguments: [DiaryType.expense, DiaryType.income])
    func validateInitializationByType(type: DiaryType) {
        // Given
        let now = Date()
        
        // When
        let diary = DiaryModel(
            date: now,
            money: 10000,
            category: .food,
            payment: .card,
            description: "테스트",
            memo: "메모",
            type: .A,
            diaryType: type
        )
        
        // Then
        #expect(diary.diaryType == type)
        #expect(diary.money == 10000)
        #expect(diary.date == now)
    }
    
    @Test("소비 유형(A, B, C) 설명 텍스트 매핑 확인", arguments: ExpenseType.allCases)
    func validateExpenseTypeDescriptions(type: ExpenseType) {
        // Given & When
        let description = type.description
        
        // Then
        let expected = switch type {
        case .A: "필수"
        case .B: "선택"
        case .C: "불필요"
        }
        #expect(description == expected)
    }

    // MARK: - 경계값 분석 (Boundary Value Analysis)
    
    @Test("금액(Money) 필드의 경계값 검증", arguments: [0, 1, Int.max])
    func validateMoneyBoundaries(amount: Int) {
        // Given & When
        let diary = DiaryModel()
        diary.money = amount
        
        // Then
        #expect(diary.money == amount)
    }
    
    @Test("ID 고유성 검증: 인스턴스 생성 시마다 서로 다른 ObjectId를 가져야 함")
    func validateIDUniqueness() {
        // Given
        let diary1 = DiaryModel()
        let diary2 = DiaryModel()
        
        // Then
        #expect(diary1.diaryID != diary2.diaryID)
    }
    
    // MARK: - 카테고리 매핑 검증
    
    @Test("전체 카테고리 타입의 rawValue 매핑 무결성 확인", arguments: DiaryCategoryType.allCases)
    func validateCategoryMapping(category: DiaryCategoryType) {
        // Given
        let diary = DiaryModel()
        
        // When
        diary.category = category
        
        // Then
        #expect(diary.category == category)
    }
}
