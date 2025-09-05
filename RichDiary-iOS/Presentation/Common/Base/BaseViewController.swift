//
//  BaseViewController.swift
//  RichDiary-iOS
//
//  Created by OneTen on 9/5/25.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setUI()
        setStyle()
        setLayout()
        addTarget()
    }
    
    
    //MARK: - Func

    open func setUI() {
        
    }
    
    open func setStyle() {
        
    }
    
    open func setLayout() {
        
    }
    
    open func addTarget() {
        
    }
    
}
