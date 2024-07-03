import UIKit

protocol CollectionScrollDelegate: AnyObject {
    func didSelectItem(at index: Int)
}

final class DatesCollectionView: UIView {
    private var presenter: CalendarViewPresenter
    private var _isProgrammaticScroll = false
    weak var collectionScrollDelegate: CollectionScrollDelegate?
    var isProgrammaticAction = false
    
    init(presenter: CalendarViewPresenter, frame: CGRect = .zero) {
        self.presenter = presenter
        super.init(frame: .zero)
        presenter.onUpdateCollection = { [weak self] in
            self?.dateCollectionView.reloadData()
        }
        presenter.loadData()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var dateCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .background
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DateCell.self, forCellWithReuseIdentifier: DateCell.reuseIdentifier)
        return collectionView
    }()
    
    private func setupCollectionView() {
        let topSeparator = createSeparator()
        let bottomSeparator = createSeparator()
        
        addSubview(dateCollectionView)
        addSubview(topSeparator)
        addSubview(bottomSeparator)
        
        NSLayoutConstraint.activate([
            topSeparator.heightAnchor.constraint(equalToConstant: 1),
            topSeparator.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            topSeparator.leadingAnchor.constraint(equalTo: leadingAnchor),
            topSeparator.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            dateCollectionView.topAnchor.constraint(equalTo: topSeparator.bottomAnchor, constant: 5),
            dateCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            dateCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            dateCollectionView.heightAnchor.constraint(equalToConstant: 80),
            
            bottomSeparator.heightAnchor.constraint(equalToConstant: 1),
            bottomSeparator.topAnchor.constraint(equalTo: dateCollectionView.bottomAnchor, constant: 5),
            bottomSeparator.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomSeparator.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomSeparator.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = UIColor.gray
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }
}


extension DatesCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCell.reuseIdentifier, for: indexPath) as? DateCell else {
            assertionFailure("Не удалось создать ячейку")
            return UICollectionViewCell()
        }
        cell.configure(with: presenter.sortedDates[indexPath.row])
        return cell
    }
    
    func selectItem(at index: Int, animated: Bool, scrollPosition: UICollectionView.ScrollPosition) {
        let indexPath = IndexPath(item: index, section: 0)
        dateCollectionView.selectItem(at: indexPath, animated: animated, scrollPosition: scrollPosition)
        dateCollectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
    }
}

extension DatesCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 65, height: 65)
    }
}

extension DatesCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isProgrammaticAction {
            collectionScrollDelegate?.didSelectItem(at: indexPath.row)
        }
        isProgrammaticAction = false
    }
}


