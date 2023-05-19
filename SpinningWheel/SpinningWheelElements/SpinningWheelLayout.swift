//
//  SpinningWheelLayout.swift
//  SpinningWheel
//
//  Created by Nikita Lazarev on 16.05.2023.
//
//

import UIKit

final class SpinningWheelLayout: UICollectionViewFlowLayout {
    
    // MARK: - Properties
    
    private var attributesList = [CircularCollectionViewLayoutAttributes]()
    private var radius: CGFloat = 300 {
        didSet {
            invalidateLayout()
        }
    }
    private var anglePerItem: CGFloat {
        return atan(itemSize.width / radius)
    }
    private var angleAtExtreme: CGFloat {
        guard let collectionView else {
            return .zero
        }
        return collectionView.numberOfItems(inSection: 0) > 0 ?
        -CGFloat(collectionView.numberOfItems(inSection: 0) - 1) * anglePerItem : 0
    }
    private var angle: CGFloat {
        guard let collectionView else {
            return .zero
        }
        return angleAtExtreme * collectionView.contentOffset.x / (collectionViewContentSize.width -
                                                                   collectionView.bounds.width)
    }
    
    // MARK: - Overriden properties
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView else {
            return .zero
        }
        return CGSize(width: CGFloat(collectionView.numberOfItems(inSection: 0)) * itemSize.width,
                      height: CGRectGetHeight(collectionView.bounds))
    }
    
    
    override class var layoutAttributesClass: AnyClass {
        return CircularCollectionViewLayoutAttributes.self
    }
    
    // MARK: - Overriden methods
    
    override func prepare() {
        super.prepare()
        setItemSize()
        setScrollDirection()
        prepareAttributes()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesList
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributesList[indexPath.row]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        // Enables scroll when items enough
        return true
    }
}

private extension SpinningWheelLayout {
    func calculateItemSize() -> CGFloat {
        guard let collectionView else {
            return .zero
        }
        
        let numberOfItems = collectionView.numberOfItems(inSection: .zero)
        let spacingBetweenCells = SpinningWheelCollectionViewCell.horizontalPadding*2
        
        let totalSpacing = CGFloat(numberOfItems - 1) * spacingBetweenCells
        let availableWidth = collectionView.bounds.width - totalSpacing
        let cellWidth = availableWidth / CGFloat(numberOfItems)
        
        return cellWidth
    }
    
    func setItemSize() {
        let itemSide = calculateItemSize()
        itemSize = CGSize(width: itemSide, height: itemSide)
    }
    
    func prepareAttributes() {
        guard let collectionView else {
            return
        }
        let centerX = collectionView.contentOffset.x + (collectionView.bounds.width / 2.0)
        attributesList = (0..<collectionView.numberOfItems(inSection: 0)).map { i in
            let attributes = CircularCollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
            let anchorPointY = ((itemSize.height / 2.0) + radius) / itemSize.height
            
            attributes.size = itemSize
            attributes.center = CGPoint(x: centerX, y: collectionView.bounds.midY)
            
            attributes.angle = angle + (anglePerItem * CGFloat(i))
            attributes.anchorPoint = CGPoint(x: 0.5, y: anchorPointY)
            
            return attributes
        }
    }
    
    func setScrollDirection() {
        scrollDirection = .horizontal
    }
}

final class CircularCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var anchorPoint = CGPoint(x: 0.5, y: 0.5)
    var angle: CGFloat = 0 {
        didSet {
            zIndex = Int(angle * 1000000)
            transform = CGAffineTransformMakeRotation(angle)
        }
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copiedAttributes: CircularCollectionViewLayoutAttributes =
        super.copy(with: zone) as! CircularCollectionViewLayoutAttributes
        copiedAttributes.anchorPoint = self.anchorPoint
        copiedAttributes.angle = self.angle
        return copiedAttributes
    }
    
}
