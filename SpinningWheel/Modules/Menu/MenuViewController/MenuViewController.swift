//
//  MenuViewController.swift
//  SpinningWheel
//
//  Created by Nikita Lazarev on 19.05.2023.
//

import UIKit
import Combine
import SwiftUI

final class MenuViewController: UIViewController {
    
    // MARK: - UI -
    
    @IBOutlet private weak var container: UIView!
    @IBOutlet private weak var blurView: UIVisualEffectView!
    @IBOutlet private weak var closeButton: RoundedButton! {
        didSet {
            closeButton.setImage(Images.menuButton.image)
            closeButton.setShadowOpacity(0.25)
            actualiseCloseButtonVisibility()
        }
    }
    private lazy var menuView: MenuView = {
        let view = MenuView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = .zero
        view.setState(viewModel.menuState)
        view.onFinishInteraction = { [weak self] selectedItem in
            self?.viewModel.onFinishMenuInteraction(with: selectedItem)
            self?.close()
        }
        view.onStateChanged = { [weak self] newValue in
            self?.viewModel.menuState = newValue
            self?.actualiseCloseButtonVisibility()
        }
        return view
    }()
        
    // MARK: - Properties -
    
    var viewModel: MenuViewModel!
    
    // MARK: - Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showMenuViewAnimated()
    }
    
    // MARK: - Actions -
    
    @IBAction private func closeButtonTapped(_ sender: UIButton) {
        sender.animateSelection {
            self.close()
        }
    }
}

// MARK: - Private methods

private extension MenuViewController {
    
    func initialSetup() {
        setupMenuView()
    }
    
    func close() {
        dismiss(animated: true)
    }
    
    func setupMenuView() {
        container.addSubview(menuView)
        
        NSLayoutConstraint.activate([
            menuView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            menuView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            menuView.heightAnchor.constraint(equalToConstant: .menuViewHeight),
            menuView.bottomAnchor.constraint(
                equalTo: closeButton.topAnchor, constant: .menuViewBottomPadding)
        ])
        
        container.layoutIfNeeded()
        
        /// Moves closeButton on top of the menuView
        container.bringSubviewToFront(closeButton)
        
        menuView.transform = .menuViewDefaultTranslation(height: menuView.bounds.height)
    }
    
    func actualiseCloseButtonVisibility() {
        closeButton.isHidden = viewModel.menuState == .interactive
    }
    
    func showMenuViewAnimated() {
        UIView.animate(withDuration: 0.3, delay: .zero, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseIn) {
            self.menuView.alpha = 1
            self.menuView.transform = .identity
        }
    }
}

// MARK: - Constants

private extension CGAffineTransform {
    static func menuViewDefaultTranslation(height: CGFloat) -> CGAffineTransform {
        CGAffineTransform(translationX: .zero, y: height)
    }
}

private extension CGFloat {
    static let menuViewHeight: CGFloat = UIScreen.main.bounds.height * .menuViewHeightCoefficient
    static let menuViewHeightCoefficient: CGFloat = 0.15
    static let menuViewBottomPadding: CGFloat = 10
}

// MARK: - IdentifiableController

extension MenuViewController: IdentifiableController {}
