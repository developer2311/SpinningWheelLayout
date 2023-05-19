//
//  MainViewController.swift
//  SpinningWheel
//
//  Created by Nikita Lazarev on 16.05.2023.
//

import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - Outlets -
    
    @IBOutlet private weak var container: UIView! {
        didSet {
            container.backgroundColor = Colors.whiteBackground.color
        }
    }
    @IBOutlet private weak var staticBackgroundImageView: UIImageView! {
        didSet {
            staticBackgroundImageView.image = Images.chartBackground.image
        }
    }
    @IBOutlet private weak var menuButton: RoundedButton! {
        didSet {
            menuButton.setImage(Images.mainButton.image)
            menuButton.alpha = .zero
        }
    }
    
    // MARK: - Life Cycle -
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initiallyPresentMenuButton()
    }
    
    // MARK: - Actions -
    
    @IBAction private func menuButonTapped(_ sender: UIButton) {
        sender.animateSelection {
            self.showMenu()
        }
    }
}

// MARK: - Private methods -

private extension MainViewController {
    func showMenu() {
        fadePresent(to: .menu)
    }
    
    func initiallyPresentMenuButton() {
        guard menuButton.alpha == .zero else {
            return
        }
        UIView.animate(
            withDuration: .presentMenuButtonAnimationDuration,
            delay: .zero,
            options: [.showHideTransitionViews, .curveEaseIn]) {
                self.menuButton.alpha = 1
            }
    }
}

private extension Double {
    static let presentMenuButtonAnimationDuration = 0.7
}

extension MainViewController: IdentifiableController {}
