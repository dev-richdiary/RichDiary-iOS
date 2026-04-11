import XCTest
import RealmSwift
@testable import RichDiary

final class RichDiaryTests: XCTestCase {
    
    func test_DiaryModel_Initialization() {
        // Given
        let now = Date()
        let money = 10000
        let description = "Test Description"
        
        // When
        let diary = DiaryModel(
            date: now,
            money: money,
            category: .food,
            payment: .card,
            description: description,
            memo: "Test Memo",
            type: .A,
            diaryType: .expense
        )
        
        // Then
        XCTAssertEqual(diary.money, money)
        XCTAssertEqual(diary.diaryDescription, description)
        XCTAssertEqual(diary.category, .food)
        XCTAssertEqual(diary.diaryType, .expense)
    }
}
