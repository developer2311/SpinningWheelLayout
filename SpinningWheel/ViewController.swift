//
//  ViewController.swift
//  SpinningWheel
//
//  Created by Nikita Lazarev on 16.05.2023.
//

import UIKit



final class ViewController: UIViewController {
    
    private lazy var dataSource: [SpinningWheelItem] = {
        let items: [SpinningWheelItem] = SpinningWheelItemType.allCases.map {
            .init(type: $0, state: .normal)
        }
        return items
    }()
    
    private lazy var collectionContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPink
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var collectionView: UICollectionView = {
        let customLayout: UICollectionViewFlowLayout = SpinningWheelLayout()
        customLayout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: customLayout
        )
        collectionView.isScrollEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupCollectionView()
    }
}

private extension ViewController {
    func setupCollectionView() {
        collectionView.register(
            SpinningWheelCollectionViewCell.self,
            forCellWithReuseIdentifier: SpinningWheelCollectionViewCell.identifier
        )
        
        let viewHeight: CGFloat = 200
        view.addSubview(collectionContainer)
        NSLayoutConstraint.activate([
            collectionContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionContainer.heightAnchor.constraint(equalToConstant: viewHeight)
        ])
        
        view.layoutIfNeeded()

        collectionContainer.pinSubview(collectionView)
        collectionView.reloadData()
    }
    
    func reconfigureCell(at indexPath: IndexPath) {
        let cell = collectionView.visibleCells[indexPath.item] as? SpinningWheelCollectionViewCell
        cell?.setState(dataSource[indexPath.item].state)
    }
    
    func updateHighlightedStates(indexPathToHighlight: IndexPath) {
        if let highlightedIndex = dataSource.firstIndex(where: {$0.state == .highlighted}) {
            dataSource[highlightedIndex].state.toggle()
            reconfigureCell(at: IndexPath(item: highlightedIndex, section: .zero))
        }
        
        let newHighlightedIndex = indexPathToHighlight.item
        dataSource[newHighlightedIndex].state.toggle()
        reconfigureCell(at: IndexPath(item: newHighlightedIndex, section: .zero))
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SpinningWheelCollectionViewCell.identifier,
            for: indexPath
        ) as! SpinningWheelCollectionViewCell
        cell.configure(with: dataSource[indexPath.item])
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateHighlightedStates(indexPathToHighlight: indexPath)
    }
}
