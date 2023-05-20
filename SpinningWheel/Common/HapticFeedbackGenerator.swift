//
//  HapticFeedbackGenerator.swift
//  SpinningWheel
//
//  Created by Nikita Lazarev on 20.05.2023.
//

import UIKit

final class HapticFeedbackGenerator {
    
    static let shared = HapticFeedbackGenerator()
    
    private init() {}
    
    func vibrateSelectionChanged() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    
    func vibrateLongPress() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}
