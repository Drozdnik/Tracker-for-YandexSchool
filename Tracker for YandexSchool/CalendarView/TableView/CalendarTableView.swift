import UIKit

final class CalendarTableView: UIView {
    private var presenter: CalendarViewPresenter
    
    init(presenter: CalendarViewPresenter, frame: CGRect = .zero) {
        self.presenter = presenter
        super.init(frame: frame)
        // Вот оно не вызывается 
        presenter.onUpdate = { [weak self] in
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
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
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
        
        if let text = presenter.textForItem(at: indexPath) {
            cell.configure(text: text)
        }
        return cell
    }
}
