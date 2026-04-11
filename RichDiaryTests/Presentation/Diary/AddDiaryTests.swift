import Testing
import UIKit
import RealmSwift
@testable import RichDiary

@MainActor
@Suite("AddDiary Real-Logic Verification")
struct AddDiaryTests {
    
    @Test("금액 0원 저장 시도 시, Realm에 데이터가 추가되지 않아야 함")
    func test_saveDiary_whenAmountIsZero_preventsDatabaseWrite() throws {
        // Given
        let realm = try Realm()
        let initialCount = realm.objects(DiaryModel.self).count
        
        let vc = AddDiaryViewController()
        vc.loadViewIfNeeded()
        
        // Reflection을 사용하여 private diaryTextFieldView에 접근 및 0원 주입
        let mirror = Mirror(reflecting: vc)
        if let textFieldView = mirror.descendant("diaryTextFieldView") as? DiaryTextFieldView {
            textFieldView.configure(with: 0, description: "테스트")
        }
        
        // When: 저장 버튼 액션 직접 호출
        vc.didTapSaveButton()
        
        // Then: 데이터가 절대 늘어나지 않아야 함
        let finalCount = realm.objects(DiaryModel.self).count
        #expect(finalCount == initialCount, "❌ 결함 발견: 금액이 0원임에도 유효성 검사를 통과하여 데이터가 저장되었습니다.")
    }
    
    @Test("정상 데이터 입력 시, Realm에 데이터가 정확히 저장되어야 함")
    func test_saveDiary_withValidData_succeeds() throws {
        // Given
        let realm = try Realm()
        let initialCount = realm.objects(DiaryModel.self).count
        
        let vc = AddDiaryViewController()
        vc.loadViewIfNeeded()
        
        // 유효한 데이터 주입
        let mirror = Mirror(reflecting: vc)
        if let textFieldView = mirror.descendant("diaryTextFieldView") as? DiaryTextFieldView {
            textFieldView.configure(with: 10000, description: "유효한 테스트")
        }
        
        // When: 저장 시도
        vc.didTapSaveButton()
        
        // Then: 데이터가 1건 늘어나야 함
        let finalCount = realm.objects(DiaryModel.self).count
        #expect(finalCount == initialCount + 1, "❌ 정상적인 데이터인데 저장이 되지 않았습니다.")
    }
}
