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
    case sixth
    case seventh
    case eighth
    case nineth
    case tenth
    
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
        case .sixth:
            return .black
        case .seventh:
            return .cyan
        case .eighth:
            return .orange
        case .nineth:
            return .darkGray
        case .tenth:
            return .yellow
        }
    }
}

struct SpinningWheelItem {
    let type: SpinningWheelItemType
    var state: SpinningWheelItemState = .normal
}
