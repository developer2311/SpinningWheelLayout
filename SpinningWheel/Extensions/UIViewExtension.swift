//
//  UIViewExtension.swift
//  SpinningWheel
//
//  Created by Nikita Lazarev on 16.05.2023.
//

import UIKit

extension UIView {
    func makeCircle() {
        clipsToBounds = true
        layer.cornerRadius = self.bounds.width / 2
    }
    
    func pinSubview(_ subview: UIView, commonInset: CGFloat? = nil) {
        addSubview(subview)
        let inset = commonInset ?? .zero
        
        NSLayoutConstraint.activate([
            subview.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: inset
            ),
            subview.topAnchor.constraint(
                equalTo: topAnchor,
                constant: inset
            ),
            subview.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -inset
            ),
            subview.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -inset
            )
        ])
        
        layoutIfNeeded()
    }
}
