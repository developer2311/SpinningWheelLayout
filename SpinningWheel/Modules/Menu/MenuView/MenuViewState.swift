//
//  MenuViewState.swift
//  SpinningWheel
//
//  Created by Nikita Lazarev on 19.05.2023.
//

import UIKit

enum MenuViewState {
    case simple
    case interactive
    
    var isItemsTitleHidden: Bool {
        switch self {
        case .interactive:
            return true
            
        case .simple:
            return false
        }
    }
    
    var isCenteredTitleHidden: Bool {
        switch self {
        case .interactive:
            return false
            
        case .simple:
            return true
        }
    }
}
