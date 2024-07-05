import UIKit

final class TableViewCell: UITableViewCell {
    static let reuseIdentifier = "TableViewCell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 1
        label.textColor = .black
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var strikeThroughView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private lazy var colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(strikeThroughView)
        contentView.addSubview(colorView)
        
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 20),
            colorView.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            strikeThroughView.heightAnchor.constraint(equalToConstant: 1),
            strikeThroughView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            strikeThroughView.trailingAnchor.constraint(equalTo: colorView.trailingAnchor),
            strikeThroughView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
    }
    
    func configure(with item: ToDoItem) {
        titleLabel.text = item.text
        strikeThroughView.isHidden = !item.flag
        if let color = item.category?.color {
            colorView.isHidden = false
            colorView.backgroundColor = UIColor(color)
        } else {
            colorView.isHidden = true
        }
    }
}
