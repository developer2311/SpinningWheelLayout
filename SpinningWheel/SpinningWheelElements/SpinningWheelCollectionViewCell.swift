//
//  SpinningWheelCollectionViewCell.swift
//  SpinningWheel
//
//  Created by Nikita Lazarev on 16.05.2023.
//

import UIKit

final class SpinningWheelCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties -
    static let identifier = String(describing: SpinningWheelCollectionViewCell.self)
    private lazy var container: UIView = {
        let view = UIView(frame: self.frame)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var itemState: SpinningWheelItemState = .normal {
        didSet {
            handleStateUpdates()
        }
    }
    
    // MARK: - Life Cycle -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContainer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupContainer()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // reset state here
        setState(.normal)
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        let circularlayoutAttributes = layoutAttributes as! CircularCollectionViewLayoutAttributes
        self.layer.anchorPoint = circularlayoutAttributes.anchorPoint
        self.center.y += (circularlayoutAttributes.anchorPoint.y - 0.5) * CGRectGetHeight(self.bounds)
    }
    
    // MARK: - Internal -
    
    func configure(with item: SpinningWheelItem) {
        container.backgroundColor = item.type.color
        setState(item.state)
        container.makeCircle()
    }
    
    func setState(_ newValue: SpinningWheelItemState) {
        guard itemState != newValue else {
            return
        }
        itemState = newValue
    }
}

// MARK: - Private methods -

private extension SpinningWheelCollectionViewCell {
    func handleStateUpdates() {
        let scaledTransform = CGAffineTransform(
            scaleX: .highlightedScaleTransformCoefficient,
            y: .highlightedScaleTransformCoefficient
        )
        
        var updatedTransform: CGAffineTransform = .identity
        var animationDuration: Double = .zero
        switch self.itemState {
        case .highlighted:
            updatedTransform = scaledTransform
            animationDuration = .updateStateToScaledAnimationDuration
        case .normal:
            updatedTransform = .identity
            animationDuration = .updateStateToDefaultAnimationDuration
        }
        
        UIView.animate(
            withDuration: animationDuration,
            delay: .zero,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.2) {
                self.container.transform = updatedTransform
                self.container.makeCircle()
                self.layoutIfNeeded()
            }
    }
    
    func setupContainer() {
        contentView.addSubview(container)
        contentView.pinSubview(container, commonInset: .containerInset)
    }
}

private extension CGFloat {
    static let highlightedScaleTransformCoefficient = 1.2
    static let containerInset: CGFloat = 10
}

private extension Double {
    static let updateStateToScaledAnimationDuration = 0.5
    static let updateStateToDefaultAnimationDuration = 0.1
}
