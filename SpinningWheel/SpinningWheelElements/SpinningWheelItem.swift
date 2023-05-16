//
//  SpinningWheelItem.swift
//  SpinningWheel
//
//  Created by Nikita Lazarev on 16.05.2023.
//

import UIKit

enum SpinningWheelItemState {
    case normal
    case highlighted
    
    mutating func toggle() {
        self = self == .highlighted ? .normal : .highlighted
    }
}

enum SpinningWheelItemType: Int, CaseIterable {
    case first = 1
    case second
    case third
    case fourth
    case fifth
    
    var color: UIColor {
        switch self {
        case .first:
            return .red
        case .second:
            return .orange
        case .third:
            return .yellow
        case .fourth:
            return .green
        case .fifth:
            return .blue
        }
    }
}

struct SpinningWheelItem {
    let type: SpinningWheelItemType
    var state: SpinningWheelItemState = .normal
}
