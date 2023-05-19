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
        }
    }
    private lazy var menuView: MenuView = {
        let view = MenuView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
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
    }
}

// MARK: - Constants

private extension CGFloat {
    static let menuViewHeight: CGFloat = UIScreen.main.bounds.height * .menuViewHeightCoefficient
    static let menuViewHeightCoefficient: CGFloat = 0.218
    static let menuViewBottomPadding: CGFloat = 32 + .collectionViewExtraSpacing
    static let collectionViewExtraSpacing: CGFloat = 15
}

// MARK: - IdentifiableController

extension MenuViewController: IdentifiableController {}
