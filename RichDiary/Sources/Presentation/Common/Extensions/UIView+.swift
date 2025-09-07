//
//  UIView+.swift
//  RichDiary-iOS
//
//  Created by OneTen on 9/5/25.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
    
    // ViewController를 찾는 함수
    func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let next = responder?.next {
            if let vc = next as? UIViewController {
                return vc
            }
            responder = next
        }
        return nil
    }
    
    func applyPillCornerRadius() {
        layoutIfNeeded()
        self.layer.cornerRadius = self.bounds.height / 2
        self.clipsToBounds = true
    }
}
