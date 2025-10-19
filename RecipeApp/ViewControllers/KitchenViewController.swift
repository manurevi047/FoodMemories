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
        
        // Create cook button
        let cookButton = UIButton(type: .system)
        cookButton.setTitle("Cook", for: .normal)
        cookButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        cookButton.backgroundColor = .systemOrange
        cookButton.setTitleColor(.white, for: .normal)
        cookButton.layer.cornerRadius = 12
        cookButton.translatesAutoresizingMaskIntoConstraints = false
        cookButton.addTarget(self, action: #selector(cookButtonTapped), for: .touchUpInside)
        view.addSubview(cookButton)
        
        // Create navigation bar buttons
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .compose,
            target: self,
            action: #selector(settingsButtonTapped)
        )
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
            tableView.bottomAnchor.constraint(equalTo: cookButton.topAnchor, constant: -12),
            
            cookButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cookButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cookButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            cookButton.heightAnchor.constraint(equalToConstant: 50)
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
            
            let quantityField = alert.textFields?[1]
            let unitField = alert.textFields?[2]
            let quantity = quantityField?.text ?? ""
            let unit = unitField?.text ?? ""
            
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
            
            let quantityField = alert.textFields?[1]
            let unitField = alert.textFields?[2]
            let quantity = quantityField?.text ?? ""
            let unit = unitField?.text ?? ""
            
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
            guard let self = self else { return }
            
            // Remove ingredient from array
            self.ingredients.remove(at: indexPath.row)
            self.saveIngredients()
            
            // Update table view with animation
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.endUpdates()
            
            // Show success feedback
            let successAlert = UIAlertController(
                title: "Deleted",
                message: "\(ingredient.name) has been removed from your ingredients.",
                preferredStyle: .alert
            )
            successAlert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(successAlert, animated: true)
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
    
    @objc private func settingsButtonTapped() {
        let settingsVC = SettingsViewController()
        let navController = UINavigationController(rootViewController: settingsVC)
        present(navController, animated: true)
    }
    
    @objc private func cookButtonTapped() {
        guard !ingredients.isEmpty else {
            let alert = UIAlertController(
                title: "No Ingredients",
                message: "Please add some ingredients before generating a recipe.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        // Show loading alert
        let loadingAlert = UIAlertController(title: "Generating Recipe", message: "Please wait while we create a delicious recipe for you...", preferredStyle: .alert)
        present(loadingAlert, animated: true)
        
        OpenAIService.shared.generateRecipe(from: ingredients) { [weak self] result in
            DispatchQueue.main.async {
                loadingAlert.dismiss(animated: true) {
                    switch result {
                    case .success(let recipe):
                        let recipeVC = RecipeViewController(recipe: recipe)
                        let navController = UINavigationController(rootViewController: recipeVC)
                        self?.present(navController, animated: true)
                        
                    case .failure(let error):
                        let errorAlert = UIAlertController(
                            title: "Error",
                            message: error.localizedDescription,
                            preferredStyle: .alert
                        )
                        errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(errorAlert, animated: true)
                    }
                }
            }
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
        
        // Set up delete button callback
        cell.onDeleteTapped = { [weak self] in
            self?.deleteIngredient(at: indexPath)
        }
        
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}

// MARK: - Custom Table View Cell
class IngredientTableViewCell: UITableViewCell {
    
    private let nameLabel = UILabel()
    private let detailsLabel = UILabel()
    private let categoryLabel = UILabel()
    private let deleteButton = UIButton(type: .system)
    
    var onDeleteTapped: (() -> Void)?
    
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
        
        deleteButton.setTitle("−", for: .normal)
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        deleteButton.setTitleColor(.black, for: .normal)
        deleteButton.backgroundColor = .clear
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        [nameLabel, detailsLabel, categoryLabel, deleteButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            categoryLabel.widthAnchor.constraint(equalToConstant: 30),
            
            nameLabel.leadingAnchor.constraint(equalTo: categoryLabel.trailingAnchor, constant: 12),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -12),
            
            detailsLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            detailsLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            detailsLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            detailsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            deleteButton.widthAnchor.constraint(equalToConstant: 24),
            deleteButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    @objc private func deleteButtonTapped() {
        onDeleteTapped?()
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
