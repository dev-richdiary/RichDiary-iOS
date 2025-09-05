//
//  BaseUIViewController.swift
//  RichDiary-iOS
//
//  Created by OneTen on 9/5/25.
//

import UIKit

import os

class BaseUIViewController: UIViewController {

    // MARK: - Properties
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Rich", category: "BaseUIViewController")
    
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setUI()
        setStyle()
        setLayout()
        addTarget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logger.log("viewWillAppear 호출 - \(type(of: self))")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logger.log("viewDidAppear 호출 - \(type(of: self))")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        logger.log("viewWillDisappear 호출 - \(type(of: self))")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        logger.log("viewDidDisappear 호출 - \(type(of: self))")
    }
    
    
    // MARK: - Func

    open func setUI() {}
    open func setStyle() {}
    open func setLayout() {}
    open func addTarget() {}
}
