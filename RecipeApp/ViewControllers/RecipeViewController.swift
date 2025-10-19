import UIKit

class RecipeViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let recipe: Recipe
    
    init(recipe: Recipe) {
        self.recipe = recipe
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupContent()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Setup navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneButtonTapped)
        )
        
        // Setup scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Create play button
        let playButton = UIButton(type: .system)
        playButton.setTitle("👨‍🍳 Cook", for: .normal)
        playButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        playButton.backgroundColor = .systemOrange
        playButton.setTitleColor(.white, for: .normal)
        playButton.layer.cornerRadius = 10
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        view.addSubview(playButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: playButton.topAnchor, constant: -12),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            playButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            playButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            playButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            playButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupContent() {
        var previousView: UIView = contentView
        let spacing: CGFloat = 20
        let sideMargin: CGFloat = 20
        
        // Recipe Title
        let titleLabel = createTitleLabel(text: recipe.title)
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: spacing),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sideMargin),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -sideMargin)
        ])
        previousView = titleLabel
        
        // Recipe Info Section
        let infoStackView = createInfoSection()
        contentView.addSubview(infoStackView)
        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: spacing),
            infoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sideMargin),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -sideMargin)
        ])
        previousView = infoStackView
        
        // Ingredients Section
        let ingredientsSection = createIngredientsSection()
        contentView.addSubview(ingredientsSection)
        NSLayoutConstraint.activate([
            ingredientsSection.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: spacing),
            ingredientsSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sideMargin),
            ingredientsSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -sideMargin)
        ])
        previousView = ingredientsSection
        
        // Directions Section
        let directionsSection = createDirectionsSection()
        contentView.addSubview(directionsSection)
        NSLayoutConstraint.activate([
            directionsSection.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: spacing),
            directionsSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sideMargin),
            directionsSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -sideMargin),
            directionsSection.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -spacing)
        ])
    }
    
    private func createTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func createInfoSection() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let sectionTitle = createSectionTitle(text: "Recipe Info")
        stackView.addArrangedSubview(sectionTitle)
        
        let servesLabel = createInfoLabel(title: "Serves:", value: "\(recipe.serves)")
        let prepTimeLabel = createInfoLabel(title: "Prep Time:", value: recipe.prepTime)
        let cookTimeLabel = createInfoLabel(title: "Cook Time:", value: recipe.cookTime)
        
        stackView.addArrangedSubview(servesLabel)
        stackView.addArrangedSubview(prepTimeLabel)
        stackView.addArrangedSubview(cookTimeLabel)
        
        return stackView
    }
    
    private func createIngredientsSection() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let sectionTitle = createSectionTitle(text: "Ingredients")
        stackView.addArrangedSubview(sectionTitle)
        
        for ingredient in recipe.ingredients {
            let ingredientLabel = createIngredientLabel(ingredient: ingredient)
            stackView.addArrangedSubview(ingredientLabel)
        }
        
        return stackView
    }
    
    private func createDirectionsSection() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let sectionTitle = createSectionTitle(text: "Directions")
        stackView.addArrangedSubview(sectionTitle)
        
        for (index, direction) in recipe.directions.enumerated() {
            let directionLabel = createDirectionLabel(text: direction, stepNumber: index + 1)
            stackView.addArrangedSubview(directionLabel)
        }
        
        return stackView
    }
    
    private func createSectionTitle(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func createInfoLabel(title: String, value: String) -> UILabel {
        let label = UILabel()
        label.text = "\(title) \(value)"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func createIngredientLabel(ingredient: RecipeIngredient) -> UILabel {
        let label = UILabel()
        let text = "• \(ingredient.quantity) \(ingredient.unit) \(ingredient.name)"
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func createDirectionLabel(text: String, stepNumber: Int) -> UILabel {
        let label = UILabel()
        
        // Remove "Step X:" prefix if it exists in the text
        let cleanedText = text.replacingOccurrences(of: "Step \\(stepNumber):", with: "", options: .regularExpression)
            .replacingOccurrences(of: "Step \\d+:", with: "", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        label.text = "• \(cleanedText)"
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    @objc private func doneButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func playButtonTapped() {
        let cookingModeVC = CookingModeViewController(recipe: recipe)
        cookingModeVC.modalPresentationStyle = .fullScreen
        present(cookingModeVC, animated: true)
    }
}
