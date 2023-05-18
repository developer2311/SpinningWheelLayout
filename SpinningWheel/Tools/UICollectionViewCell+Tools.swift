//
//  UICollectionViewCell+Tools.swift
//  SpinningWheel
//
//  Created by Nikita Lazarev on 18.05.2023.
//

import UIKit

protocol CellIdentifying: AnyObject {
    static var identifier: String { get }
}

extension CellIdentifying {
    static var identifier: String {
        return String(describing: Self.self)
    }
}

protocol CollectionCellDequeueable: CellIdentifying {
    static func cell<T: UICollectionViewCell>(
        in collection: UICollectionView,
        at indexPath: IndexPath
    ) -> T
}

extension CollectionCellDequeueable {
    static func cell<T: UICollectionViewCell>(
        in collection: UICollectionView,
        at indexPath: IndexPath
    ) -> T  {
        guard let cell = collection.dequeueReusableCell(
            withReuseIdentifier: identifier,
            for: indexPath
        ) as? T else {
            fatalError("Could not dequeue cell with identifier: \(identifier) of type \(T.self)")
        }
        return cell
    }
}

protocol CollectionCellRegistable: CellIdentifying {
    static func registerClass(in collection: UICollectionView)
}

extension CollectionCellRegistable {
    static func registerClass(in collection: UICollectionView) {
        collection.register(Self.self, forCellWithReuseIdentifier: identifier)
    }
}
