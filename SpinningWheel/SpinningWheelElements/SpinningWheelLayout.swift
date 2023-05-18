//
//  SpinningWheelLayout.swift
//  SpinningWheel
//
//  Created by Nikita Lazarev on 16.05.2023.
//
//

import UIKit

class SpinningWheelLayout: UICollectionViewFlowLayout {
    private var cellAttributes: [UICollectionViewLayoutAttributes] = []
    private var radius: CGFloat = 0
    private var angularSpacing: CGFloat = 0
    private var cellSize: CGSize = .zero
    private let cellSpacing: CGFloat = 10 // Constant spacing between cells

    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }

        let itemCount = collectionView.numberOfItems(inSection: 0)
        let centerX = collectionView.bounds.width * 0.5
        let centerY = collectionView.bounds.height * 0.5

        cellSize = CGSize(width: 70, height: 70) // Adjust the cell size as needed
        radius = min(collectionView.bounds.width, collectionView.bounds.height) * 0.5 - max(cellSize.width, cellSize.height)
        angularSpacing = .pi / CGFloat(itemCount - 1) // Adjust the angular spacing for the bottom half of a circle

        cellAttributes.removeAll()

        for item in 0..<itemCount {
            let indexPath = IndexPath(item: item, section: 0)
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)

            let angle = CGFloat(item) * angularSpacing
            let cellCenterX = centerX + radius * cos(angle)
            let cellCenterY = centerY - radius * sin(angle) // Flip the vertical direction
            attribute.center = CGPoint(x: cellCenterX, y: cellCenterY)
            attribute.size = cellSize

            cellAttributes.append(attribute)
        }

        adjustCellPositions()
    }

    private func adjustCellPositions() {
        guard let collectionView = collectionView else { return }

        let contentWidth = collectionView.bounds.width
        let totalCellWidth = (cellSize.width * CGFloat(cellAttributes.count)) + (cellSpacing * CGFloat(cellAttributes.count - 1))
        let leftPadding = (contentWidth - totalCellWidth) / 2

        var xOffset: CGFloat = leftPadding

        for attribute in cellAttributes {
            attribute.frame = CGRect(x: xOffset, y: attribute.frame.origin.y, width: attribute.frame.width, height: attribute.frame.height)
            xOffset += attribute.frame.width + cellSpacing
        }
    }

    override var collectionViewContentSize: CGSize {
        let itemCount = collectionView?.numberOfItems(inSection: 0) ?? 0
        let contentWidth = cellSize.width * CGFloat(itemCount) + cellSpacing * CGFloat(itemCount - 1)
        let contentHeight = collectionView?.bounds.height ?? 0
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cellAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellAttributes[indexPath.item]
    }

}

