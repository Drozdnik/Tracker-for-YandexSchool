import UIKit

final class CalendarViewController: UIViewController {
    private var fileCache: FileCache
    private var presenter: CalendarViewPresenter
    private var tableView: CalendarTableView
    private var collectionView: DatesCollectionView
    
    init(fileCache: FileCache) {
        self.fileCache = fileCache
        self.presenter = CalendarViewPresenter(fileCache: fileCache)
        self.tableView = CalendarTableView(presenter: presenter)
        self.collectionView = DatesCollectionView(presenter: presenter)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .background
        view.addSubview(collectionView)
        view.addSubview(tableView)
        view.backgroundColor = .background
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
