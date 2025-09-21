//
//  SplashViewController.swift
//  RichDiary
//
//  Created by OneTen on 9/22/25.
//

import UIKit

import SnapKit

final class SplashViewController: UIViewController {
    
    // MARK: - UI Components

    private lazy var logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        imageView.image = UIImage(resource: .iconRichdiary)
        
        return imageView
    }()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setUI()
        setLayout()
    }
    
    
    // MARK: - Private Func
    
    private func setUI() {
        view.backgroundColor = UIColor(resource: .appIconBackground)
        
        view.addSubview(logoImage)
    }
    
    private func setLayout() {
        logoImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
    }
}
