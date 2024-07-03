import UIKit
import SwiftUI

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
        setupSUIButton()
        collectionView.selectionDelegate = self
        self.title = "Мои дела"
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
    
    private func setupSUIButton() {
        let button = PlusView {
            self.showCreateToDoItem()
        }
        
        let buttonHostingController = UIHostingController(rootView: button)
        addChild(buttonHostingController)
        view.addSubview(buttonHostingController.view)
        buttonHostingController.didMove(toParent: self)
        buttonHostingController.view.backgroundColor = .clear
        
        buttonHostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonHostingController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            buttonHostingController.view.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    private func showCreateToDoItem() {
        let createToDoItemView = CreateToDoItem(viewModel: CreateToDoItemViewModel(fileCache: fileCache)){ [weak self] in
            self?.presenter.loadData()
            self?.presenter.onUpdate?()
        }
        let viewHostingController = UIHostingController(rootView: createToDoItemView)
        self.present(viewHostingController, animated: true)
    }
}

extension CalendarViewController: DatesCollectionViewDelgate {
    func didSelectItemAt(index: Int) {
        tableView.scrollToSection(index: index)
    }
}
