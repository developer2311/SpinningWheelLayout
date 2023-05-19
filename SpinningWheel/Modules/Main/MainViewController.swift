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
            menuButton.addGestureRecognizer(longPressGesture)
        }
    }
    
    // MARK: - Properties -
    
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let recognizer = UILongPressGestureRecognizer(
            target: self,
            action: #selector(handleLongPressGesture(_:))
        )
        recognizer.minimumPressDuration = .showMenuLongPressDuration
        return recognizer
    }()
    private lazy var menuViewModel: MenuViewModel = {
        let viewModel = MenuViewModel()
        viewModel.delegate = self
        return viewModel
    }()
    
    
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
    
    @objc private func handleLongPressGesture(_ recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .began:
            UIView.animate(withDuration: 0.5) {
                self.menuButton.transform = .scaledTransform
            }
        case .ended:
            showMenu(isInteractive: true)
            self.menuButton.transform = .identity
        default:
            break
        }
    }
}

// MARK: - Private methods -

private extension MainViewController {
    func showMenu(isInteractive: Bool = false) {
        let menuState: MenuViewState = isInteractive ? .interactive : .simple
        menuViewModel.menuState = menuState
        fadePresent(to: .menu(viewModel: menuViewModel))
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
 
// MARK: - MenuViewModelDelegate -

extension MainViewController: MenuViewModelDelegate {
    func didSelectAction(_ itemType: SpinningWheelItemType) {
        presentAlert(title: "!Action!", message: itemType.title)
    }
}

private extension Double {
    static let presentMenuButtonAnimationDuration = 0.7
    static let showMenuLongPressDuration = 0.5
}

extension MainViewController: IdentifiableController {}
