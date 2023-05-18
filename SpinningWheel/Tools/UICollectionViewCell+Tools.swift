//
//  UICollectionViewCell+Tools.swift
//  SpinningWheel
//
//  Created by Nikita Lazarev on 18.05.2023.
//

import UIKit

protocol Identifiable: AnyObject {
    ///
    /// Returns an identifier of an object that conforms this protocol. Type of `String`.
    ///
    static var identifier: String { get }
}

extension Identifiable {
    static var identifier: String {
        return String(describing: Self.self)
    }
}

protocol CollectionCellDequeueable: Identifiable {
    ///
    /// Dequeues reusable collection cell that is used in `cellForItem(at:)` method of `UICollectionViewDataSource`
    /// - parameters:
    ///   - collection: A collection view that is going to dequeue the cell. Type of `UICollectionView`.
    ///   - indexPath: An index path of the cell that's going to be dequeued. Type of `IndexPath`.
    /// - returns: A reusable cell instance that is going to be dequeued. Type of `T`.
    /// NOTE: `T` is a generic type that requires the original type to inherit from `UICollectionViewCell`.
    ///
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

protocol CollectionCellRegistable: Identifiable {
    ///
    /// Register reusable collection view cell in a collection view.
    /// - parameters:
    ///   - collection: A collection view that is going to register the cell. Type of `UICollectionView`.
    ///
    static func registerClass(in collection: UICollectionView)
}

extension CollectionCellRegistable {
    static func registerClass(in collection: UICollectionView) {
        collection.register(Self.self, forCellWithReuseIdentifier: identifier)
    }
}
