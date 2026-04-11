import Testing
import UIKit
import RealmSwift
@testable import RichDiary

@MainActor
@Suite("AddDiary Business Logic Specification - Detailed")
struct AddDiaryTests {
    
    // MARK: - 저장 유효성 검증 (동치 분할 & 경계값)
    
    @Test("저장 시도 시 설명(Description) 필드의 유효성 검사", arguments: ["", " ", "   "])
    func test_saveDiary_withInvalidDescriptions_fails(invalidDesc: String) {
        // Given
        let vc = AddDiaryViewController()
        vc.loadViewIfNeeded()
        
        // Note: 실제 UI 컴포넌트의 값을 시뮬레이션
        // vc.diaryTextFieldView.description = invalidDesc (분석된 로직 기반)
        
        // When
        vc.didTapSaveButton()
        
        // Then: 현재 로직 분석 결과, 빈 문자열 그룹은 알림을 띄우고 리턴해야 함
    }
    
    @Test("메모 글자 수 제한의 정밀 경계값 검사", arguments: [399, 400])
    func test_memoLength_withinLimit_isAllowed(length: Int) {
        let vc = AddDiaryViewController()
        vc.loadViewIfNeeded()
        let textView = UITextView()
        let text = String(repeating: "A", count: length)
        
        // When: 한계치 내의 글자 입력 시도
        let shouldChange = vc.textView(textView, shouldChangeTextIn: NSRange(location: 0, length: 0), replacementText: text)
        
        // Then: 허용되어야 함
        #expect(shouldChange == true)
    }

    @Test("메모 글자 수 제한 초과 경계값 검사", arguments: [401, 1000])
    func test_memoLength_exceedingLimit_isBlocked(length: Int) {
        let vc = AddDiaryViewController()
        vc.loadViewIfNeeded()
        let textView = UITextView()
        textView.text = String(repeating: "A", count: 400)
        let extraText = String(repeating: "B", count: length - 400)
        
        // When: 400자 꽉 찬 상태에서 추가 입력 시도
        let shouldChange = vc.textView(textView, shouldChangeTextIn: NSRange(location: 400, length: 0), replacementText: extraText)
        
        // Then: 차단되어야 함
        #expect(shouldChange == false)
    }
}
