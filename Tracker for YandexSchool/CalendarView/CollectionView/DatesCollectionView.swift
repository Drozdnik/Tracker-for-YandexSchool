import UIKit

final class DatesCollectionView: UIView {
    private var presenter: CalendarViewPresenter
    
    init(presenter: CalendarViewPresenter) {
        self.presenter = presenter
        presenter.loadData()
        super.init(frame: .zero)
        setupCollectionView()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var dateCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
//        layout.itemSize = CGSize(width: 100, height: 100)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .background
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(DateCell.self, forCellWithReuseIdentifier: DateCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private func setupCollectionView() {
        addSubview(dateCollectionView)
        
        NSLayoutConstraint.activate([
            dateCollectionView.topAnchor.constraint(equalTo: topAnchor),
            dateCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            dateCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dateCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
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
}

extension DatesCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
