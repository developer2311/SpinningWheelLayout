//
//  MenuView.swift
//  SpinningWheel
//
//  Created by Nikita Lazarev on 18.05.2023.
//

import UIKit

typealias SpinningWheelItemInteractiomCompletion = (_ selectedItem: SpinningWheelItem?) -> Void

final class MenuView: UIView {
    
    // MARK: - Interaction -
    
    var onFinishInteraction: SpinningWheelItemInteractiomCompletion?
    var onStateChanged: ((_ newValue: MenuViewState) -> Void)?
    var onChangeSelectedItem: SpinningWheelItemInteractiomCompletion?
    
    // MARK: - UI Elements -
    
    private lazy var dataSource: [SpinningWheelItem] = {
        let items: [SpinningWheelItem] = SpinningWheelItemType.allCases.map {
            .init(type: $0, state: .normal)
        }
        return items
    }()
    
    private lazy var collectionContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: SpinningWheelLayout()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    // MARK: - Private properties -
    
    private lazy var panGesture: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer(
            target: self,
            action: #selector(handlePanGesture(_:))
        )
        return recognizer
    }()
    private var state: MenuViewState = .simple {
        didSet {
            onStateChanged?(state)
            collectionView.reloadData()
        }
    }
    private var selectedItemIndex: Int? {
        didSet {
            onChangeSelectedItem?(selectedItem)
        }
    }
    private var selectedItem: SpinningWheelItem? {
        guard let selectedItemIndex else {
            return nil
        }
        return dataSource[selectedItemIndex]
    }
    
    
    // MARK: - Life Cycle -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        alignContent()
    }
    
    // MARK: - Internal -
    
    func setState(_ state: MenuViewState) {
        self.state = state
    }
}

// MARK: - Private methods -

private extension MenuView {
    func initialSetup() {
        setupCollectionView()
    }
    
    func alignContent() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.collectionView.centerContentHorizontalyByInsetIfNeeded(minimumInset: .zero)
        }
    }
    
    func setupCollectionView() {
        SpinningWheelCollectionViewCell.registerClass(in: collectionView)
        layoutCollectionView()
        collectionContainer.addGestureRecognizer(panGesture)
    }
    
    func layoutCollectionView() {
        pinSubview(collectionContainer)
        collectionContainer.pinSubview(collectionView)
    }
    
    func reconfigureCell(at indexPath: IndexPath) {
        if let cell = getCell(at: indexPath) {
            cell.setState(dataSource[indexPath.item].state)
        }
    }
    
    func getCell(at indexPath: IndexPath) -> SpinningWheelCollectionViewCell? {
        collectionView.cellForItem(at: indexPath) as? SpinningWheelCollectionViewCell
    }
    
    ///
    /// Updates current highlighted item by deselecting the old one and selecting a new one
    /// - parameters:
    ///    - indexPathToHighlight: Index of the item that is going to be highlighted after the selection. Type of `IndexPath`
    ///
    func updateHighlightedStates(indexPathToHighlight: IndexPath) {
        // Prevents the duplication action for the cell in the same index
        if let selectedItemIndex,
           indexPathToHighlight.item == selectedItemIndex {
            return
        }
        
        // Dehighlights the old highlighted value before highlighting a new one
        if let highlightedIndex = dataSource.firstIndex(where: {$0.state == .highlighted}) {
            guard highlightedIndex != indexPathToHighlight.item else {
                return
            }
            dataSource[highlightedIndex].state.toggle()
            reconfigureCell(at: IndexPath(item: highlightedIndex, section: .zero))
        }

        // Highlights a new item
        let newHighlightedIndex = indexPathToHighlight.item
        self.selectedItemIndex = newHighlightedIndex

        dataSource[newHighlightedIndex].state.toggle()
        
        // Finishes interaction and passes a selected item only when a state is not interactive
        if state == .simple {
            if let cell = getCell(at: indexPathToHighlight) {
                cell.animateCellSelection {
                    self.onFinishInteraction?(self.selectedItem)
                }
            }
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.reconfigureCell(at: IndexPath(item: newHighlightedIndex, section: .zero))
        }
    }
    
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let touchLocation = recognizer.location(in: collectionContainer)
        
        switch recognizer.state {
        case .began:
            // Switches to interactive state when pan gesture is detected
            if state != .interactive {
                state = .interactive
            }
            highlightItemIfIntersects(with: touchLocation)
        case .changed:
            highlightItemIfIntersects(with: touchLocation)
        case .ended:
            guard state == .interactive else {
                return
            }
            onFinishInteraction?(selectedItem)
        default:
            break
        }
    }
    
    func highlightItemIfIntersects(with location: CGPoint) {
        for cell in collectionView.visibleCells {
            if cell.frame.contains(location),
               let indexPath = collectionView.indexPath(for: cell) {
                updateHighlightedStates(indexPathToHighlight: indexPath)
                break
            }
        }
    }
    
//    func actualiseSelectedItemVisibility() {
//        UIView.animate(withDuration: .selectedItemVisibilityAnimationDuration) {
//            self.selectedItemLabel.alpha = self.state == .simple ? .zero : 1
//            self.selectedItemLabel.isHidden = self.state == .simple
//        }
//    }
}

// MARK: - UICollectionViewDataSource -

extension MenuView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SpinningWheelCollectionViewCell = .cell(in: collectionView, at: indexPath)
        cell.configure(
            with: dataSource[indexPath.item],
            shouldHideTitle: state.isItemsTitleHidden
        )
        return cell
    }
}

// MARK: - UICollectionViewDelegate -

extension MenuView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateHighlightedStates(indexPathToHighlight: indexPath)
    }
}
