//
//  SpinningWheelCollectionViewCell.swift
//  SpinningWheel
//
//  Created by Nikita Lazarev on 16.05.2023.
//

import UIKit

final class SpinningWheelCollectionViewCell: UICollectionViewCell,
                                             CollectionCellRegistable,
                                             CollectionCellDequeueable {
    
    // MARK: - Properties -
    private lazy var buttonTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .BRHendrixBold(of: .buttonFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var buttonImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var container: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var itemState: SpinningWheelItemState = .normal {
        didSet {
            handleStateUpdates()
        }
    }
    private var attributes: CircularCollectionViewLayoutAttributes?
    static let horizontalPadding: CGFloat = 10
    
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
        self.attributes = circularlayoutAttributes
        self.layer.anchorPoint = circularlayoutAttributes.anchorPoint
        self.center.y += (circularlayoutAttributes.anchorPoint.y - 0.5) * CGRectGetHeight(self.bounds)
    }
    
    // MARK: - Internal -
    
    func configure(with item: SpinningWheelItem) {
        container.backgroundColor = Colors.redPrimary.color
        setupButton(with: item)
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
        contentView.pinSubview(container, commonInset: SpinningWheelCollectionViewCell.horizontalPadding)
    }
    
    func setupButton(with item: SpinningWheelItem) {
        /// rotate to 0
        //        if let attributes = attributes {
        //            let zeroAngle = -attributes.angle + 0.45
        //            buttonImageView.transform = CGAffineTransformMakeRotation(zeroAngle)
        //            buttonTitleLabel.transform = CGAffineTransformMakeRotation(zeroAngle)
        //        }
        
        buttonImageView.image = item.type.image
        buttonTitleLabel.text = item.type.title
        
        contentView.addSubview(buttonTitleLabel)
        container.addSubview(buttonImageView)
        
        NSLayoutConstraint.activate([
            buttonImageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            buttonImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            buttonTitleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            buttonTitleLabel.bottomAnchor.constraint(equalTo: container.topAnchor, constant: -7)
        ])
    }
    
}

private extension CGFloat {
    static let highlightedScaleTransformCoefficient = 1.2
}

private extension Double {
    static let updateStateToScaledAnimationDuration = 0.5
    static let updateStateToDefaultAnimationDuration = 0.1
}

// MARK: - Constants

private extension CGFloat {
    static let buttonFontSize: CGFloat = 14
}

