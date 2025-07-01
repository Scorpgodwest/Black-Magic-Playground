import UIKit

class CardCell: UICollectionViewCell {
    static let identifier = "CardCell"
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var rarityView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var rarityLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 10)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .systemGreen
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var manaCostLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(typeLabel)
        containerView.addSubview(rarityView)
        rarityView.addSubview(rarityLabel)
        containerView.addSubview(priceLabel)
        containerView.addSubview(manaCostLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            
            manaCostLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            manaCostLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            manaCostLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            
            typeLabel.topAnchor.constraint(equalTo: manaCostLabel.bottomAnchor, constant: 4),
            typeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            typeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            
            rarityView.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 8),
            rarityView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            rarityView.heightAnchor.constraint(equalToConstant: 20),
            rarityView.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            
            rarityLabel.topAnchor.constraint(equalTo: rarityView.topAnchor, constant: 2),
            rarityLabel.leadingAnchor.constraint(equalTo: rarityView.leadingAnchor, constant: 8),
            rarityLabel.trailingAnchor.constraint(equalTo: rarityView.trailingAnchor, constant: -8),
            rarityLabel.bottomAnchor.constraint(equalTo: rarityView.bottomAnchor, constant: -2),
            
            priceLabel.topAnchor.constraint(equalTo: rarityView.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            priceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            priceLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with card: Card) {
        nameLabel.text = card.name
        typeLabel.text = card.type
        rarityLabel.text = card.rarity.displayName.uppercased()
        rarityView.backgroundColor = card.rarity.color
        priceLabel.text = "$\(String(format: "%.2f", card.price))"
        manaCostLabel.text = card.manaCost ?? ""
        
        // Add subtle animation on configuration
        transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        UIView.animate(withDuration: 0.2) {
            self.transform = .identity
        }
    }
}