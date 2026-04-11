import XCTest
import RxSwift
import RxTest

@testable import RichDiary

final class {{Name}}ViewModelTests: XCTestCase {
    
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    private var viewModel: {{Name}}ViewModel!
    // private var mockUseCase: Mock{{Name}}UseCase!
    
    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        // mockUseCase = Mock{{Name}}UseCase()
        // viewModel = {{Name}}ViewModel(useCase: mockUseCase)
    }
    
    override func tearDown() {
        scheduler = nil
        disposeBag = nil
        viewModel = nil
        super.tearDown()
    }
    
    func test_onAction_updatesOutput() {
        // Given
        // let action = scheduler.createHotObservable([ .next(10, ()) ])
        // action.bind(to: viewModel.input.someAction).disposed(by: disposeBag)
        
        // let observer = scheduler.createObserver(String.self)
        // viewModel.output.someOutput.bind(to: observer).disposed(by: disposeBag)
        
        // When
        // scheduler.start()
        
        // Then
        // XCTAssertEqual(observer.events, [ ... ])
    }
}
