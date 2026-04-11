import Foundation
import RxSwift
import RxRelay

final class {{Name}}ViewModel {
    
    // MARK: - Properties
    
    let input: Input
    let output: Output
    private let disposeBag = DisposeBag()
    
    
    // MARK: - Init
    
    init() {
        // 1. Initialize Relays
        let someRelay = PublishRelay<Void>()
        
        // 2. Initialize Input/Output
        self.input = Input()
        self.output = Output()
        
        // 3. Bind logic
        bind(input: self.input, output: self.output)
    }
    
    private func bind(input: Input, output: Output) {
        // Reactive logic here
    }
}

// MARK: - ViewModelType

extension {{Name}}ViewModel: ViewModelType {
    struct Input {
        // let someAction: PublishRelay<Void>
    }
    
    struct Output {
        // let someData: BehaviorRelay<String>
    }
}
