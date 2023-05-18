//
//  UIViewExtension.swift
//  SpinningWheel
//
//  Created by Nikita Lazarev on 16.05.2023.
//

import UIKit

extension UIView {
    
    /// Makes a view rounded as a circle shape.
    func makeCircle() {
        clipsToBounds = true
        layer.cornerRadius = self.bounds.width / 2
    }
    
    ///
    /// Adds a subview to itself and layouts it inside by pinning to edges. Provides a posibility to add a common inset for all sides.
    /// - parameters:
    ///   - subview: A subview that's going to be added and pinned. Type of `UIView`.
    ///   - commonInset: A fixed inset that could be used to all edges. Type of `CGFloat`. Is optional.
    ///
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
