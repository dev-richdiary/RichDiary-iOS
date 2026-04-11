import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class {{Name}}ViewController: BaseUIViewController {
    
    // MARK: - Properties
    
    private let viewModel: {{Name}}ViewModel
    private let disposeBag = DisposeBag()
    
    
    // MARK: - UI Components
    
    // private let exampleView = UIView().then {
    //     $0.backgroundColor = .white
    // }
    
    
    // MARK: - Init
    
    init(viewModel: {{Name}}ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    
    // MARK: - Override Func
    
    override func setUI() {
        // Add Subviews
        // self.view.addSubviews(exampleView)
    }
    
    override func setStyle() {
        // Configure styles
    }
    
    override func setLayout() {
        // SnapKit layout
        // exampleView.snp.makeConstraints { ... }
    }
    
    
    // MARK: - Private Func
    
    private func bind() {
        // Input binding (View -> ViewModel)
        
        // Output binding (ViewModel -> View)
    }
}
