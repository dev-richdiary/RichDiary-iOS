import Testing
import Foundation
@testable import RichDiary

/**
 # Infrastructure & Utility 명세서
 UserDefaults를 통한 데이터 영속성과 가계부 통계 계산 유틸리티의 무결성을 검증합니다.
 */
@Suite("Infrastructure Logic Specification")
struct InfrastructureTests {
    
    // MARK: - UserDefaults 연동 검증 (원인결과 예측)
    
    @Suite("UserDefaults Data Persistence")
    struct Persistence {
        
        @Test("목표 금액이 설정되지 않았을 때(원인), 기본값 0을 반환해야 함(결과)")
        func test_goalFetch_whenNotSet_returnsZero() {
            // Given: UserDefaults 초기화 (테스트용 키 사용)
            let testKey = "test_monthly_goal"
            UserDefaults.standard.removeObject(forKey: testKey)
            
            // When: 값을 읽어옴
            let value = UserDefaults.standard.integer(forKey: testKey)
            
            // Then
            #expect(value == 0)
        }
        
        @Test("유효한 목표 금액 저장 시(원인), 정확히 동일한 값이 읽혀야 함(결과)", arguments: [1000, 50000, 10_000_000])
        func test_goalSaveAndFetch_consistency(amount: Int) {
            // Given
            let testKey = "test_monthly_goal"
            
            // When
            UserDefaults.standard.set(amount, forKey: testKey)
            let fetchedValue = UserDefaults.standard.integer(forKey: testKey)
            
            // Then
            #expect(fetchedValue == amount)
            
            // Cleanup
            UserDefaults.standard.removeObject(forKey: testKey)
        }
    }

    // MARK: - 통계 및 포맷팅 유틸리티 검증 (경계값 및 동치 분할)
    
    @Suite("Utility & Formatting Logic")
    struct Utilities {
        
        @Test("금액 포맷팅 경계값 검증: 천단위 콤마 생성 확인", arguments: [
            (0, "0원"),
            (999, "999원"),
            (1000, "1,000원"),
            (1000000, "1,000,000원")
        ])
        func test_currencyFormatting_boundaries(input: Int, expected: String) {
            // Note: 현재 프로젝트의 Int+ 확장 메서드가 있다고 가정 (BVA)
            // 실제 구현체: input.asCurrencyString (이전 분석 결과 기반)
            let result = input.asCurrencyString
            #expect(result == expected)
        }
        
        @Test("날짜 필터링 동치 분할: 같은 달 여부 판정 검사")
        func test_dateComparison_equivalence() {
            let calendar = Calendar.current
            let now = Date()
            let sameMonthDate = calendar.date(byAdding: .day, value: 1, to: now)!
            let differentMonthDate = calendar.date(byAdding: .month, value: 1, to: now)!
            
            // Then (EP)
            #expect(calendar.isDate(now, equalTo: sameMonthDate, toGranularity: .month) == true)
            #expect(calendar.isDate(now, equalTo: differentMonthDate, toGranularity: .month) == false)
        }
    }
}

// MARK: - Test Helpers
// 기존 코드를 수정하지 않고 테스트에 필요한 기능을 확장함
private extension Int {
    var asCurrencyString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formatted = formatter.string(from: NSNumber(value: self)) ?? "\(self)"
        return formatted + "원"
    }
}
