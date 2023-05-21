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
    
    private lazy var container: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var buttonTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .BRHendrixBold(of: .buttonFontSize)
        label.textColor = Colors.buttonTextPrimary.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var buttonImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var imageContainer: UIView = {
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
    
    func configure(with item: SpinningWheelItem, shouldHideTitle: Bool) {
        imageContainer.backgroundColor = Colors.redPrimary.color
        buttonTitleLabel.isHidden = shouldHideTitle
        setupContainers(with: item)
        setState(item.state)
        imageContainer.makeCircle()
    }
    
    func setState(_ newValue: SpinningWheelItemState) {
        guard itemState != newValue else {
            return
        }
        itemState = newValue
    }
    
    func animateCellSelection(animationDuration: Double = 0.3, completion: EmptyBlock? = nil) {
        
        container.animateSelection(completion: completion)
    }
}

// MARK: - Private methods -

private extension SpinningWheelCollectionViewCell {
    func handleStateUpdates() {
        var updatedTransform: CGAffineTransform = .identity
        var animationDuration: Double = .zero
        switch self.itemState {
        case .highlighted:
            updatedTransform = .scaledTransform
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
                self.imageContainer.transform = updatedTransform
                self.buttonTitleLabel.transform = updatedTransform
                self.imageContainer.makeCircle()
                self.layoutIfNeeded()
            }
    }
    
    func setupContainer() {
        contentView.pinSubview(container, commonInset: SpinningWheelCollectionViewCell.horizontalPadding)
        container.pinSubview(imageContainer)
    }
    
    func setupContainers(with item: SpinningWheelItem) {
        setupTitle(with: item)
        setupImage(with: item)
    }
    
    func setupTitle(with item: SpinningWheelItem) {
        buttonTitleLabel.text = item.type.title
        container.addSubview(buttonTitleLabel)
        NSLayoutConstraint.activate([
            buttonTitleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            buttonTitleLabel.bottomAnchor.constraint(equalTo: container.topAnchor, constant: -7)
        ])
    }
    
    func setupImage(with item: SpinningWheelItem) {
        buttonImageView.image = item.type.image
        imageContainer.addSubview(buttonImageView)
        NSLayoutConstraint.activate([
            buttonImageView.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor),
            buttonImageView.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor)
        ])
    }
}

private extension Double {
    static let updateStateToScaledAnimationDuration = 0.5
    static let updateStateToDefaultAnimationDuration = 0.1
}

// MARK: - Constants

private extension CGFloat {
    static let buttonFontSize: CGFloat = 14
}

