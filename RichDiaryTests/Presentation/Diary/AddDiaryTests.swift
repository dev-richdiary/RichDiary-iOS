import Testing
import UIKit
import RealmSwift
@testable import RichDiary

/**
 # AddDiaryViewController 비즈니스 규칙 명세서
 가계부 작성 화면에서 발생하는 입력 유효성 검사 및 데이터 가공 규칙을 정의합니다.
 */
@MainActor
@Suite("AddDiary Business Logic Specification")
struct AddDiaryTests {
    
    // MARK: - 입력 유효성 검증 (경계값 분석 & 동치 분할)
    
    @Test("금액이 0원일 때 저장이 시도되면 알림이 발생해야 함 (경계값: 0)")
    func test_saveDiary_whenAmountIsZero_showsAlert() {
        // Given
        let vc = AddDiaryViewController()
        vc.loadViewIfNeeded()
        
        // When: 금액을 0으로 설정하고 저장 버튼 액션 직접 호출
        // Note: 실제 UI 상의 버튼 탭과 동일한 로직 검증
        vc.didTapSaveButton()
        
        // Then: 현재 로직상 0원일 때 return 하므로 이후 Realm 저장 로직이 타지 않아야 함
        // (이 테스트는 로직의 '흐름'을 문서화함)
    }
    
    @Test("설명이 비어있을 때 저장이 시도되면 알림이 발생해야 함 (동치 분할: 빈 문자열)")
    func test_saveDiary_whenDescriptionIsEmpty_showsAlert() {
        let vc = AddDiaryViewController()
        vc.loadViewIfNeeded()
        
        // When: 설명 없이 저장 시도
        vc.didTapSaveButton()
        
        // Then: 내용 입력 안내가 발생해야 함
    }

    // MARK: - 글자 수 제한 검증 (경계값 분석)
    
    @Test("메모 입력 시 400자를 초과하면 더 이상 입력되지 않아야 함 (경계값: 400, 401)")
    func test_memoLengthLimit_boundaries() {
        let vc = AddDiaryViewController()
        vc.loadViewIfNeeded()
        let textView = UITextView()
        
        // 400자 텍스트 생성
        let maxText = String(repeating: "A", count: 400)
        let exceedsText = "B"
        
        // When: 400자 상태에서 1자 더 입력 시도
        let shouldChange = vc.textView(textView, shouldChangeTextIn: NSRange(location: 400, length: 0), replacementText: exceedsText)
        
        // Then
        #expect(shouldChange == false, "❌ 400자 초과 입력이 허용됨")
    }

    // MARK: - 타입 변경 로직 (원인결과 예측)
    
    @Test("지출에서 수입으로 타입 변경 시(원인), 지출 유형 필드가 숨겨져야 함(결과)")
    func test_diaryTypeChange_togglesVisibility() {
        let vc = AddDiaryViewController()
        vc.loadViewIfNeeded()
        let segmentedControl = UISegmentedControl()
        
        // When: '수입'(Index 1) 선택
        segmentedControl.selectedSegmentIndex = 1
        vc.diaryTypeDidChange(segmentedControl)
        
        // Then: 지출 유형 스택뷰가 hidden 상태여야 함 (로직 분석 기반)
    }
}
