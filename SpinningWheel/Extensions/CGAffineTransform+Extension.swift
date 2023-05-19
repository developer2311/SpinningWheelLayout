//
//  CGAffineTransform+Extension.swift
//  SpinningWheel
//
//  Created by Nikita Lazarev on 20.05.2023.
//

import Foundation

extension CGAffineTransform {
    static let scaledTransform = CGAffineTransform(
        scaleX: .highlightedScaleTransformCoefficient,
        y: .highlightedScaleTransformCoefficient
    )
}
