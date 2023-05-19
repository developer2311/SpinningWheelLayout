//
//  NavigationRoute.swift
//  SpinningWheel
//
//  Created by Nikita Lazarev on 19.05.2023.
//

import UIKit

enum NavigationRoute {
    case main
    case menu
    
    var storyboardScreen: StoryboardScreen {
        switch self {
        case .main:
            return .main
            
        case .menu:
            return .menu
        }
    }
}

enum StoryboardScreen {
    case main
    case menu
    
    func instance() -> UIViewController {
        switch self {
        case .main:
            let instance: MainViewController = StoryboardScreen.instance()
            return instance
            
        case .menu:
            let instance: MenuViewController = StoryboardScreen.instance()
            return instance
        }
    }
}

fileprivate extension StoryboardScreen {
    static func instance<ScreenClass: IdentifiableController>() -> ScreenClass {
        let identifier = ScreenClass.identifier
        let storyboard = UIStoryboard(name: identifier, bundle: nil)
        
        guard let screenInstance = storyboard.instantiateViewController(withIdentifier: identifier) as? ScreenClass else {
            fatalError("Couldn't find `\(identifier)` view controller in scope!")
        }
        return screenInstance
    }
}
