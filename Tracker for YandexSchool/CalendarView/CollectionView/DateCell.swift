import UIKit

class DateCell: UICollectionViewCell {
    static let reuseIdentifier = "DateCell"

    override var isSelected: Bool {
        didSet {
            updateSelectedState()
        }
    }

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(monthLabel)
        
        contentView.backgroundColor = UIColor.background
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            monthLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor),
            monthLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }

    func configure(with date: String) {
        let date = date.split(separator: " ").map({String($0)})
        if date.count == 2 {
            dateLabel.text = date[0]
            monthLabel.text = date[1]
            monthLabel.isHidden = false
        } else {
            dateLabel.text = date[0]
            monthLabel.isHidden = true
        }
    }
    
    private func updateSelectedState() {
        if isSelected {
            contentView.backgroundColor = UIColor.selectedCollection
            contentView.layer.borderColor = UIColor.darkGray.cgColor
            contentView.layer.cornerRadius = 10
            contentView.layer.borderWidth = 2
            contentView.layer.borderColor = UIColor.gray.cgColor
            contentView.layer.masksToBounds = true
            contentView.translatesAutoresizingMaskIntoConstraints = false
        } else {
            contentView.backgroundColor = UIColor.background
            contentView.layer.borderWidth = 0
        }
    }
}
