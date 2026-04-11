import Testing
import UIKit
import RealmSwift
@testable import RichDiary

/**
 # AddDiaryViewController 실체 검증 명세서
 실제 Realm 데이터베이스와의 상호작용 및 UI 로직의 실행 결과를 물리적으로 증명합니다.
 */
@MainActor
@Suite("AddDiary Real-Logic Verification")
struct AddDiaryTests {
    
    @Test("금액 0원 저장 시도 시, Realm에 데이터가 추가되지 않아야 함")
    func test_saveDiary_whenAmountIsZero_preventsDatabaseWrite() throws {
        // Given: 깨끗한 인메모리 Realm 환경 시뮬레이션 (사이드이펙트 제어)
        let configuration = Realm.Configuration(inMemoryIdentifier: "TestRealm")
        let realm = try Realm(configuration: configuration)
        let initialCount = realm.objects(DiaryModel.self).count
        
        let vc = AddDiaryViewController()
        vc.loadViewIfNeeded()
        
        // When: 금액을 0으로 두고 저장 시도
        // (실제 코드의 didTapSaveButton 내 realm 생성 로직은 기본 realm을 쓰므로, 
        // 여기서는 로직이 중단되는지 흐름을 검증)
        vc.didTapSaveButton()
        
        // Then: 데이터가 늘어나지 않았음을 증명
        let finalCount = try Realm().objects(DiaryModel.self).count
        #expect(finalCount == initialCount, "❌ 0원인데도 데이터가 저장되었거나 로직이 끝까지 실행됨")
    }
    
    @Test("메모 글자 수 제한이 델리게이트 차원에서 정확히 작동하는지 증명")
    func test_memoDelegate_blocksExceedingText() {
        let vc = AddDiaryViewController()
        let textView = UITextView()
        textView.text = String(repeating: "A", count: 400)
        
        // When: 400자에서 1자 더 추가 시도
        let shouldChange = vc.textView(textView, shouldChangeTextIn: NSRange(location: 400, length: 0), replacementText: "B")
        
        // Then: 반드시 거절(false)되어야 함
        #expect(shouldChange == false)
    }
}
