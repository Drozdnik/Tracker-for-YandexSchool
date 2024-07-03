import UIKit

protocol TableScrollDelegate: AnyObject {
    func didScrollToSection(index: Int)
}

final class CalendarTableView: UIView {
    private var presenter: CalendarViewPresenter
    var isProgrammaticAction = false
    weak var tableScrollDelegate: TableScrollDelegate?
    
    init(presenter: CalendarViewPresenter, frame: CGRect = .zero) {
        self.presenter = presenter
        super.init(frame: frame)
        presenter.onUpdateTable = { [weak self] in
            self?.tableView.reloadData()
        }
        
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.dataSource = self
        table.delegate = self
        table.contentInsetAdjustmentBehavior = .never
        table.register(CalendarTableViewHeader.self, forHeaderFooterViewReuseIdentifier: CalendarTableViewHeader.reuseIdentifier)
        table.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseIdentifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private func setupTableView() {
        addSubview(tableView)
        backgroundColor = .background
        tableView.backgroundColor = .background
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

extension CalendarTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func scrollToSection(index: Int) {
        let indexPath = IndexPath(row: 0, section: index)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isProgrammaticAction else {
            isProgrammaticAction = false
            return
        }
        
        let visibleRows = tableView.indexPathsForVisibleRows
        let visibleSections = Set(visibleRows?.map { $0.section } ?? [])
        if let firstVisibleSection = visibleSections.min() {
            tableScrollDelegate?.didScrollToSection(index: firstVisibleSection)
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let completeAction = UIContextualAction(style: .normal, title: nil) { [weak self] action, view, completionHandler in
            self?.presenter.toggleCompletion(at: indexPath)
            tableView.reloadRows(at: [indexPath], with: .none)
            completionHandler(true)
        }
        completeAction.backgroundColor = .systemGreen
        completeAction.image = UIImage(systemName: "checkmark.circle.fill")  // Используйте системную иконку

        return UISwipeActionsConfiguration(actions: [completeAction])
    }

    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let uncompleteAction = UIContextualAction(style: .normal, title: nil) { [weak self] action, view, completionHandler in
            self?.presenter.toggleCompletion(at: indexPath)
            tableView.reloadRows(at: [indexPath], with: .none)
            completionHandler(true)
        }
        uncompleteAction.backgroundColor = .systemRed
        uncompleteAction.image = UIImage(systemName: "xmark.app")

        return UISwipeActionsConfiguration(actions: [uncompleteAction])
    }
}


extension CalendarTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CalendarTableViewHeader.reuseIdentifier) as? CalendarTableViewHeader else {
            return nil
        }
        
        header.setTitle(presenter.titleForHeaderInSection(section: section))
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        
        if let item = presenter.getItem(at: indexPath) {
            cell.configure(with: item)
        }
        
        cell.selectionStyle = .none
        return cell
    }
}


