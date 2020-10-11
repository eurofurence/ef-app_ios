import UIKit

protocol DaysHorizontalPickerViewDelegate: class {
    
    func daysHorizontalPickerView(_ pickerView: DaysHorizontalPickerView, didSelectDayAt index: Int)
    
}

class DaysHorizontalPickerView: UIView {
    
    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.scrollDirection = .horizontal
        
        let smallFrameSoCollectionViewWillLayout = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        return UICollectionView(frame: smallFrameSoCollectionViewWillLayout, collectionViewLayout: collectionViewLayout)
    }()
    
    weak var delegate: DaysHorizontalPickerViewDelegate?
    
    func bind(numberOfDays: Int, using binder: ScheduleDaysBinder) {
        daysController = DaysController(
            numberOfDays: numberOfDays,
            binder: binder,
            onDaySelected: dayPickerDidSelectDay
        )
    }
    
    func selectDay(at index: Int) {
        collectionView.selectItem(at: IndexPath(item: index, section: 0),
                                  animated: true,
                                  scrollPosition: .centeredHorizontally)
    }
    
    func forceLayout() {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    private func setUp() {
        backgroundColor = .clear
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ScheduleDayCollectionViewCell.self)
        
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        forceLayout()
    }
    
    private var daysController: DaysController? {
        didSet {
            collectionView.dataSource = daysController
            collectionView.delegate = daysController
            forceLayout()
        }
    }
    
    private func dayPickerDidSelectDay(_ index: Int) {
        delegate?.daysHorizontalPickerView(self, didSelectDayAt: index)
    }
    
    private class DaysController: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
        private let numberOfDays: Int
        private let binder: ScheduleDaysBinder
        private let onDaySelected: (Int) -> Void
        
        init(numberOfDays: Int, binder: ScheduleDaysBinder, onDaySelected: @escaping (Int) -> Void) {
            self.numberOfDays = numberOfDays
            self.binder = binder
            self.onDaySelected = onDaySelected
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return numberOfDays
        }
        
        func collectionView(
            _ collectionView: UICollectionView,
            cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {
            let cell = collectionView.dequeue(ScheduleDayCollectionViewCell.self, for: indexPath)
            binder.bind(cell, forDayAt: indexPath.item)
            return cell
        }
        
        func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout, 
            sizeForItemAt indexPath: IndexPath
        ) -> CGSize {
            let availableWidth = collectionView.safeAreaLayoutGuide.layoutFrame.width
            
            let sensibleMinimumWidth: CGFloat = 64
            let numberOfItems = collectionView.numberOfItems(inSection: indexPath.section)
            let itemWidth = max(sensibleMinimumWidth, availableWidth / CGFloat(numberOfItems))
            
            return CGSize(width: itemWidth, height: collectionView.bounds.height)
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            onDaySelected(indexPath.item)
        }
        
    }
    
}
