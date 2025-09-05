//
//  UIStackView+.swift
//  RichDiary-iOS
//
//  Created by OneTen on 9/5/25.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { addArrangedSubview($0) }
    }
}
