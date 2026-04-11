import Testing
import Foundation
import RealmSwift
@testable import RichDiary

@Suite("DiaryModel Logic Specification - Advanced")
struct DiaryModelTests {
    
    // MARK: - 경계값 분석 (BVA) 고도화
    
    @Test("금액(Money) 필드 극한의 경계값 테스트", arguments: [Int.min, -1, 0, 1, Int.max])
    func validateMoneyExtremeBoundaries(amount: Int) {
        let diary = DiaryModel()
        diary.money = amount
        #expect(diary.money == amount)
    }
    
    @Test("메모 필드 텍스트 무결성 테스트 (이모지 및 특수문자 포함)")
    func validateMemoIntegrity() {
        // Given: 다양한 인코딩이 섞인 텍스트
        let complexText = "🔥 RichDiary! \n개행문자 포함\n!@#$%^&*()_+ Korean 한글"
        let diary = DiaryModel()
        
        // When
        diary.memo = complexText
        
        // Then
        #expect(diary.memo == complexText)
        #expect(diary.memo.count > 0)
    }

    // MARK: - 동치 분할 (EP) 고도화
    
    @Test("카테고리 enum과 rawValue 간의 1:1 매핑 전수 검사", arguments: DiaryCategoryType.allCases)
    func validateAllCategoryMappings(category: DiaryCategoryType) {
        let diary = DiaryModel()
        diary.category = category
        
        // Then: 정의된 모든 카테고리가 손실 없이 매핑되는지 확인
        #expect(diary.category == category)
        #expect(!category.description.isEmpty)
    }
}
