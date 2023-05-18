//
//  RoundedButton.swift
//  SpinningWheel
//
//  Created by Nikita Lazarev on 19.05.2023.
//

import UIKit

final class RoundedButton: UIButton {
    
    // MARK: - Life Cycle -
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    // MARK: - Internal -
    
    func setImage(_ image: UIImage?) {
        setImage(image, for: .normal)
    }
}

private extension RoundedButton {
    func setup() {
        makeCircle()
        addDropShadow()
    }
}
