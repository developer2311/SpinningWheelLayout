//
//  UIViewExtension.swift
//  SpinningWheel
//
//  Created by Nikita Lazarev on 16.05.2023.
//

import UIKit

public typealias EmptyBlock = () -> ()

extension UIView {
    
    // MARK: - Layers -
    
    /// Makes a view rounded as a circle shape.
    func makeCircle() {
        clipsToBounds = true
        layer.cornerRadius = self.bounds.width / 2
    }
    
    func addDropShadow(
        with color: UIColor = Colors.blackShadow.color,
        cornerRadius: CGFloat? = nil,
        corners: UIRectCorner = .allCorners,
        shadowRadius: CGFloat = 34,
        shadowOffset: CGSize = .zero,
        shadowOpacity: Float = 0.4
    ) {
        let cgPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius ?? self.layer.cornerRadius).cgPath
        self.layer.shadowPath = cgPath
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
        self.layer.masksToBounds = false
        self.clipsToBounds = false
    }
    
    // MARK: - Layout -
    
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
    
    func pinExceptTop(
        _ subview: UIView,
        subviewHeight: CGFloat,
        insets: UIEdgeInsets
    ) {
        addSubview(subview)
        
        NSLayoutConstraint.activate([
            subview.heightAnchor.constraint(equalToConstant: subviewHeight),
            subview.leftAnchor.constraint(
                equalTo: leftAnchor,
                constant: insets.left
            ),
            subview.rightAnchor.constraint(
                equalTo: rightAnchor,
                constant: -insets.right
            ),
            subview.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -insets.bottom
            )
        ])
        
        layoutIfNeeded()
    }
    
    // MARK: - Animations -
    
    func animateSelection(
        animationDuration: Double = 0.3,
        completion: EmptyBlock? = nil
    ) {
        self.isUserInteractionEnabled = false
        self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        
        UIView.animate(
            withDuration: animationDuration,
            delay: .zero,
            usingSpringWithDamping: CGFloat(0.9),
            initialSpringVelocity: CGFloat(1.0),
            options: UIView.AnimationOptions.curveEaseInOut,
            animations: {
                self.transform = CGAffineTransform.identity
            },
            completion: { Void in
                completion?()
                self.isUserInteractionEnabled = true
            }
        )
    }
}
