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

enum SpinningWheelItemType: CaseIterable {
    case stake
    case send
    case receive
    case supply
    case borrow
    
    var image: UIImage {
        switch self {
        case .stake:
            return Images.stakeButton.image
        case .send:
            return Images.sendButton.image
        case .receive:
            return Images.recieveButton.image
        case .supply:
            return Images.supplyButton.image
        case .borrow:
            return Images.borrowButton.image
        }
    }
    
    var title: String {
        switch self {
        case .stake:
            return .stakeItemTitle
            
        case .send:
            return .sendItemTitle
            
        case .receive:
            return .receiveItemTitle
            
        case .supply:
            return .supplyItemTitle
            
        case .borrow:
            return .borrowItemTitle
        }
    }
}

struct SpinningWheelItem {
    let type: SpinningWheelItemType
    var state: SpinningWheelItemState = .normal
}

private extension String {
    static let stakeItemTitle = "Stake"
    static let sendItemTitle = "Send"
    static let receiveItemTitle = "Receive"
    static let supplyItemTitle = "Supply"
    static let borrowItemTitle = "Borrow"
}
