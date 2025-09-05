//
//  BaseUIView.swift
//  RichDiary-iOS
//
//  Created by OneTen on 9/5/25.
//

import UIKit

class BaseUIView: UIView {

    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
        setStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Func
    
    func setUI() {}
    func setLayout() {}
    func setStyle() {}
}
