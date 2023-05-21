//
//  MenuViewModel.swift
//  SpinningWheel
//
//  Created by Nikita Lazarev on 20.05.2023.
//

import Foundation

protocol MenuViewModelDelegate: AnyObject {
    func didSelectAction(_ itemType: SpinningWheelItemType)
}

final class MenuViewModel: ObservableObject {
    
    // MARK: - Properties -
    
    weak var delegate: MenuViewModelDelegate?
    var menuState: MenuViewState = .simple
    
    // MARK: - Internal -
    
    func onFinishMenuInteraction(with selectedItem: SpinningWheelItem?) {
        guard let type = selectedItem?.type else {
            return
        }
        delegate?.didSelectAction(type)
    }
    
}
