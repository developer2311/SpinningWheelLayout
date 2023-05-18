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
        return collectionView!.numberOfItems(inSection: 0) > 0 ?
        -CGFloat(collectionView!.numberOfItems(inSection: 0) - 1) * anglePerItem : 0
    }
    private var angle: CGFloat {
        return angleAtExtreme * collectionView!.contentOffset.x / (collectionViewContentSize.width -
                                                                   CGRectGetWidth(collectionView!.bounds))
    }
    
    
    // MARK: - Overriden properties
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: CGFloat(collectionView!.numberOfItems(inSection: 0)) * itemSize.width,
                      height: CGRectGetHeight(collectionView!.bounds))
    }
    
    
    override class var layoutAttributesClass: AnyClass {
        return CircularCollectionViewLayoutAttributes.self
    }
    
    // MARK: - Overriden methods
    
    override func prepare() {
        super.prepare()
        
        let centerX = collectionView!.contentOffset.x + (collectionView!.bounds.width / 2.0)
        itemSize = .init(width: 70, height: 70)
        
        scrollDirection = .horizontal
        attributesList = (0..<collectionView!.numberOfItems(inSection: 0)).map { i in
            let attributes = CircularCollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
            let anchorPointY = ((itemSize.height / 2.0) + radius) / itemSize.height
            
            attributes.size = itemSize
            attributes.center = CGPoint(x: centerX, y: collectionView!.bounds.midY)
            
            attributes.angle = angle + (anglePerItem * CGFloat(i))
            attributes.anchorPoint = CGPoint(x: 0.5, y: anchorPointY)
            
            return attributes
        }
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
