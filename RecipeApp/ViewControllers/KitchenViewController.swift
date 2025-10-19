import UIKit

class KitchenViewController: UIViewController {
    
    private var tableView: UITableView!
    
    private var ingredients: [Ingredient] = []
    private let userDefaults = UserDefaults.standard
    private let ingredientsKey = "SavedIngredients"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadIngredients()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func setupUI() {
        title = "Kitchen"
        view.backgroundColor = .systemBackground
        
        // Create table view
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(IngredientTableViewCell.self, forCellReuseIdentifier: "IngredientCell")
        view.addSubview(tableView)
        
        // Create add button
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addIngredientTapped)
        )
        
        // Setup constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func addIngredientTapped() {
        let alert = UIAlertController(title: "Add Ingredient", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Ingredient name"
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Quantity (optional)"
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Unit (optional)"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let self = self,
                  let nameField = alert.textFields?[0],
                  let name = nameField.text,
                  !name.isEmpty else { return }
            
            let quantity = alert.textFields?[1]?.text ?? ""
            let unit = alert.textFields?[2]?.text ?? ""
            
            let newIngredient = Ingredient(name: name, quantity: quantity, unit: unit)
            self.ingredients.append(newIngredient)
            self.saveIngredients()
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func editIngredient(_ ingredient: Ingredient, at indexPath: IndexPath) {
        let alert = UIAlertController(title: "Edit Ingredient", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.text = ingredient.name
            textField.placeholder = "Ingredient name"
        }
        
        alert.addTextField { textField in
            textField.text = ingredient.quantity
            textField.placeholder = "Quantity (optional)"
        }
        
        alert.addTextField { textField in
            textField.text = ingredient.unit
            textField.placeholder = "Unit (optional)"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let self = self,
                  let nameField = alert.textFields?[0],
                  let name = nameField.text,
                  !name.isEmpty else { return }
            
            let quantity = alert.textFields?[1]?.text ?? ""
            let unit = alert.textFields?[2]?.text ?? ""
            
            self.ingredients[indexPath.row] = Ingredient(name: name, quantity: quantity, unit: unit, category: ingredient.category)
            self.saveIngredients()
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func deleteIngredient(at indexPath: IndexPath) {
        let ingredient = ingredients[indexPath.row]
        
        let alert = UIAlertController(
            title: "Delete Ingredient",
            message: "Are you sure you want to delete \(ingredient.name)?",
            preferredStyle: .alert
        )
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.ingredients.remove(at: indexPath.row)
            self?.saveIngredients()
            self?.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func saveIngredients() {
        if let encoded = try? JSONEncoder().encode(ingredients) {
            userDefaults.set(encoded, forKey: ingredientsKey)
        }
    }
    
    private func loadIngredients() {
        if let data = userDefaults.data(forKey: ingredientsKey),
           let decoded = try? JSONDecoder().decode([Ingredient].self, from: data) {
            ingredients = decoded
        }
    }
}

// MARK: - UITableViewDataSource
extension KitchenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as! IngredientTableViewCell
        let ingredient = ingredients[indexPath.row]
        cell.configure(with: ingredient)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension KitchenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let ingredient = ingredients[indexPath.row]
        editIngredient(ingredient, at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteIngredient(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete"
    }
}

// MARK: - Custom Table View Cell
class IngredientTableViewCell: UITableViewCell {
    
    private let nameLabel = UILabel()
    private let detailsLabel = UILabel()
    private let categoryLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        detailsLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        detailsLabel.textColor = .secondaryLabel
        categoryLabel.font = UIFont.systemFont(ofSize: 20)
        
        [nameLabel, detailsLabel, categoryLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            categoryLabel.widthAnchor.constraint(equalToConstant: 30),
            
            nameLabel.leadingAnchor.constraint(equalTo: categoryLabel.trailingAnchor, constant: 12),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            detailsLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            detailsLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            detailsLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            detailsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with ingredient: Ingredient) {
        nameLabel.text = ingredient.name
        categoryLabel.text = ingredient.category.emoji
        
        var details = [String]()
        if !ingredient.quantity.isEmpty {
            details.append(ingredient.quantity)
        }
        if !ingredient.unit.isEmpty {
            details.append(ingredient.unit)
        }
        detailsLabel.text = details.joined(separator: " ")
    }
}
