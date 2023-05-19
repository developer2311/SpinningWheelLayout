//
//  MenuViewController.swift
//  SpinningWheel
//
//  Created by Nikita Lazarev on 19.05.2023.
//

import UIKit

final class MenuViewController: UIViewController {
    
    // MARK: - UI -
    @IBOutlet private weak var container: UIView!
    @IBOutlet private weak var blurView: UIVisualEffectView!
    @IBOutlet private weak var closeButton: RoundedButton! {
        didSet {
            closeButton.setImage(Images.menuButton.image)
            closeButton.setShadowOpacity(0.25)
        }
    }
    private lazy var menuView: MenuView = {
        let view = MenuView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = .zero
        return view
    }()
    
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
            self.dismiss(animated: true)
        }
    }
}

// MARK: - Private methods

private extension MenuViewController {
    
    func initialSetup() {
        setupMenuView()
    }
    
    func setupMenuView() {
        container.pinExceptTop(
            menuView,
            subviewHeight: .menuViewHeight,
            insets: .init(
                top: .zero,
                left: .zero,
                bottom: .menuViewBottomPadding,
                right: .zero
            )
        )
        
        /// Moves closeButton on top of the menuView
        container.bringSubviewToFront(closeButton)
        
        menuView.transform = .menuViewDefaultTranslation(height: menuView.bounds.height)
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
    static let menuViewHeightCoefficient: CGFloat = 0.218
    static let menuViewBottomPadding: CGFloat = 32 + .collectionViewExtraSpacing
    static let collectionViewExtraSpacing: CGFloat = 15
}

// MARK: - IdentifiableController

extension MenuViewController: IdentifiableController {}
