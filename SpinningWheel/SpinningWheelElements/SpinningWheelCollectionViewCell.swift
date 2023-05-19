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
        label.font = FontFamily.BRHendrix.bold.font(size: Constants.buttonFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var buttonImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var button: UIView = {
        let view = UIView(frame: self.frame)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var itemState: SpinningWheelItemState = .normal {
        didSet {
            handleStateUpdates()
        }
    }
    private var attributes: CircularCollectionViewLayoutAttributes?
    
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
        button.backgroundColor = Colors.redPrimary.color
        setupButton(with: item)
        setState(item.state)
        button.makeCircle()
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
                self.button.transform = updatedTransform
                self.button.makeCircle()
                self.layoutIfNeeded()
            }
    }
    
    func setupContainer() {
        contentView.pinSubview(button, commonInset: .containerInset)
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
        button.addSubview(buttonImageView)
        
        NSLayoutConstraint.activate([
            buttonImageView.heightAnchor.constraint(equalToConstant: Constants.buttonImageHeight),
            buttonImageView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            buttonImageView.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            buttonTitleLabel.heightAnchor.constraint(equalToConstant: Constants.titleLabelHeight),
            buttonTitleLabel.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            buttonTitleLabel.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -7)
        ])
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

// MARK: - Constants

private extension SpinningWheelCollectionViewCell {
    enum Constants {
        static let titleLabelHeight: CGFloat = 18
        static let buttonImageHeight: CGFloat = 17
        static let buttonFontSize: CGFloat = 14
    }
}

