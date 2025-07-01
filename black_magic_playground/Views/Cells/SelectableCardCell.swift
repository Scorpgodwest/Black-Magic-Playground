import UIKit

class SelectableCardCell: UICollectionViewCell {
    static let identifier = "SelectableCardCell"
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.clear.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var rarityView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var rarityLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 8)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 10)
        label.textColor = .systemGreen
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var selectionIndicator: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark.circle.fill")
        imageView.tintColor = .systemBlue
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        containerView.addSubview(rarityView)
        rarityView.addSubview(rarityLabel)
        containerView.addSubview(priceLabel)
        containerView.addSubview(selectionIndicator)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            selectionIndicator.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4),
            selectionIndicator.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4),
            selectionIndicator.widthAnchor.constraint(equalToConstant: 20),
            selectionIndicator.heightAnchor.constraint(equalToConstant: 20),
            
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4),
            
            rarityView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            rarityView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            rarityView.heightAnchor.constraint(equalToConstant: 16),
            rarityView.widthAnchor.constraint(greaterThanOrEqualToConstant: 40),
            
            rarityLabel.topAnchor.constraint(equalTo: rarityView.topAnchor, constant: 1),
            rarityLabel.leadingAnchor.constraint(equalTo: rarityView.leadingAnchor, constant: 4),
            rarityLabel.trailingAnchor.constraint(equalTo: rarityView.trailingAnchor, constant: -4),
            rarityLabel.bottomAnchor.constraint(equalTo: rarityView.bottomAnchor, constant: -1),
            
            priceLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4),
            priceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4),
            priceLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with card: Card, isSelected: Bool) {
        nameLabel.text = card.name
        rarityLabel.text = card.rarity.displayName.prefix(1).uppercased()
        rarityView.backgroundColor = card.rarity.color
        priceLabel.text = "$\(String(format: "%.2f", card.price))"
        
        selectionIndicator.isHidden = !isSelected
        containerView.layer.borderColor = isSelected ? UIColor.systemBlue.cgColor : UIColor.clear.cgColor
        
        // Add selection animation
        if isSelected {
            UIView.animate(withDuration: 0.2) {
                self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.transform = .identity
            }
        }
    }
}