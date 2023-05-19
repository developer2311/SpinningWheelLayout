//
//  RoundedButton.swift
//  SpinningWheel
//
//  Created by Nikita Lazarev on 19.05.2023.
//

import UIKit

final class RoundedButton: UIButton {
    
    private var shadowOpacity: Float = 0.4
    
    // MARK: - Life Cycle -
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    // MARK: - Internal -
    
    func setImage(_ image: UIImage?) {
        setImage(image, for: .normal)
    }
    
    func setShadowOpacity(_ value: Float) {
        shadowOpacity = value
    }
}

private extension RoundedButton {
    func setup() {
        makeCircle()
        addDropShadow(shadowOpacity: shadowOpacity)
    }
}
