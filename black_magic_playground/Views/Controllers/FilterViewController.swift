import UIKit

class FilterViewController: UIViewController {
    
    private let viewModel: CollectionViewModel
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    init(viewModel: CollectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "Filters"
        view.backgroundColor = .systemGroupedBackground
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelTapped)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Clear",
            style: .plain,
            target: self,
            action: #selector(clearTapped)
        )
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func clearTapped() {
        viewModel.clearFilters()
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension FilterViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3 // Rarity, Color, Sort
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return CardRarity.allCases.count
        case 1: return CardColor.allCases.count
        case 2: return CollectionViewModel.SortOption.allCases.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Rarity"
        case 1: return "Color"
        case 2: return "Sort By"
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        switch indexPath.section {
        case 0:
            let rarity = CardRarity.allCases[indexPath.row]
            cell.textLabel?.text = rarity.displayName
            cell.accessoryType = viewModel.selectedRarity == rarity ? .checkmark : .none
            
        case 1:
            let color = CardColor.allCases[indexPath.row]
            cell.textLabel?.text = color.displayName
            cell.accessoryType = viewModel.selectedColor == color.rawValue ? .checkmark : .none
            
        case 2:
            let sortOption = CollectionViewModel.SortOption.allCases[indexPath.row]
            cell.textLabel?.text = sortOption.rawValue
            cell.accessoryType = viewModel.sortOption == sortOption ? .checkmark : .none
            
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            let rarity = CardRarity.allCases[indexPath.row]
            viewModel.selectedRarity = viewModel.selectedRarity == rarity ? nil : rarity
            
        case 1:
            let color = CardColor.allCases[indexPath.row]
            viewModel.selectedColor = viewModel.selectedColor == color.rawValue ? nil : color.rawValue
            
        case 2:
            let sortOption = CollectionViewModel.SortOption.allCases[indexPath.row]
            viewModel.sortOption = sortOption
            
        default:
            break
        }
        
        tableView.reloadData()
    }
}