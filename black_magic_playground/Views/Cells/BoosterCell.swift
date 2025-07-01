import UIKit

class BoosterCell: UITableViewCell {
    static let identifier = "BoosterCell"
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var setLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .systemYellow
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cardCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var boosterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "gift.fill")
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(boosterImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(setLabel)
        containerView.addSubview(priceLabel)
        containerView.addSubview(cardCountLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            boosterImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            boosterImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            boosterImageView.widthAnchor.constraint(equalToConstant: 50),
            boosterImageView.heightAnchor.constraint(equalToConstant: 50),
            
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: boosterImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: -8),
            
            setLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            setLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            setLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            cardCountLabel.topAnchor.constraint(equalTo: setLabel.bottomAnchor, constant: 4),
            cardCountLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            cardCountLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            priceLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            priceLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60)
        ])
    }
    
    func configure(with booster: Booster, canAfford: Bool) {
        nameLabel.text = booster.name
        setLabel.text = booster.setName
        priceLabel.text = "\(booster.price) 💰"
        cardCountLabel.text = "\(booster.cardCount) cards"
        
        containerView.alpha = canAfford ? 1.0 : 0.6
        nameLabel.textColor = canAfford ? .label : .systemGray
        priceLabel.textColor = canAfford ? .systemYellow : .systemGray
    }
}