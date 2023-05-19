//
//  UIViewController+Extension.swift
//  SpinningWheel
//
//  Created by Nikita Lazarev on 19.05.2023.
//

import UIKit

protocol IdentifiableController: UIViewController, SelfIdentifiable {}

extension UIViewController {
    func navigate(to navigationRoute: NavigationRoute, animated: Bool = true) {
        let screenInstance = navigationRoute.storyboardScreen.instance()
        navigationController?.pushViewController(screenInstance,
                                                 animated: animated)
    }
    
    func fadePresent(to navigationRoute: NavigationRoute, animated: Bool = true) {
        let screenInstance = navigationRoute.storyboardScreen.instance()
        screenInstance.modalTransitionStyle = .crossDissolve
        screenInstance.modalPresentationStyle = .overCurrentContext
        navigationController?.present(screenInstance, animated: animated)
    }
}
