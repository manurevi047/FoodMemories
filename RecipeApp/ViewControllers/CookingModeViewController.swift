import UIKit

class CookingModeViewController: UIViewController {
    
    private let recipe: Recipe
    private var currentStepIndex = 0
    
    private let backgroundView = UIView()
    private let instructionLabel = UILabel()
    private let closeButton = UIButton(type: .system)
    
    private let bottomToolbar = UIView()
    private let backButton = UIButton(type: .system)
    private let stepIndicatorLabel = UILabel()
    private let forwardButton = UIButton(type: .system)
    
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
        updateDisplay()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        // Setup background view
        backgroundView.backgroundColor = .black
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)
        
        // Setup close button
        closeButton.setTitle("✕", for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        closeButton.layer.cornerRadius = 20
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        view.addSubview(closeButton)
        
        // Setup instruction label
        instructionLabel.font = UIFont.systemFont(ofSize: 28, weight: .regular)
        instructionLabel.textColor = .white
        instructionLabel.textAlignment = .center
        instructionLabel.numberOfLines = 0
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(instructionLabel)
        
        // Setup bottom toolbar
        bottomToolbar.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        bottomToolbar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomToolbar)
        
        // Setup back button
        backButton.setTitle("←", for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        backButton.setTitleColor(.white, for: .normal)
        backButton.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        backButton.layer.cornerRadius = 25
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        bottomToolbar.addSubview(backButton)
        
        // Setup step indicator
        stepIndicatorLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        stepIndicatorLabel.textColor = .white
        stepIndicatorLabel.textAlignment = .center
        stepIndicatorLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomToolbar.addSubview(stepIndicatorLabel)
        
        // Setup forward button
        forwardButton.setTitle("→", for: .normal)
        forwardButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        forwardButton.setTitleColor(.white, for: .normal)
        forwardButton.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        forwardButton.layer.cornerRadius = 25
        forwardButton.translatesAutoresizingMaskIntoConstraints = false
        forwardButton.addTarget(self, action: #selector(forwardButtonTapped), for: .touchUpInside)
        bottomToolbar.addSubview(forwardButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Background view
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Close button
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40),
            
            // Instruction label
            instructionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            // Bottom toolbar
            bottomToolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomToolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomToolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomToolbar.heightAnchor.constraint(equalToConstant: 80),
            
            // Back button
            backButton.leadingAnchor.constraint(equalTo: bottomToolbar.leadingAnchor, constant: 30),
            backButton.centerYAnchor.constraint(equalTo: bottomToolbar.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 50),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Step indicator
            stepIndicatorLabel.centerXAnchor.constraint(equalTo: bottomToolbar.centerXAnchor),
            stepIndicatorLabel.centerYAnchor.constraint(equalTo: bottomToolbar.centerYAnchor),
            
            // Forward button
            forwardButton.trailingAnchor.constraint(equalTo: bottomToolbar.trailingAnchor, constant: -30),
            forwardButton.centerYAnchor.constraint(equalTo: bottomToolbar.centerYAnchor),
            forwardButton.widthAnchor.constraint(equalToConstant: 50),
            forwardButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func updateDisplay() {
        let currentStep = currentStepIndex + 1
        let totalSteps = recipe.directions.count
        
        // Update instruction
        if currentStepIndex < recipe.directions.count {
            instructionLabel.text = recipe.directions[currentStepIndex]
        }
        
        // Update step indicator
        stepIndicatorLabel.text = "\(currentStep) / \(totalSteps)"
        
        // Update button states
        backButton.alpha = currentStepIndex == 0 ? 0.3 : 1.0
        backButton.isEnabled = currentStepIndex > 0
        
        forwardButton.alpha = currentStepIndex == recipe.directions.count - 1 ? 0.3 : 1.0
        forwardButton.isEnabled = currentStepIndex < recipe.directions.count - 1
        
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func backButtonTapped() {
        guard currentStepIndex > 0 else { return }
        currentStepIndex -= 1
        
        // Animate transition
        UIView.transition(with: instructionLabel, duration: 0.3, options: .transitionCrossDissolve) {
            self.updateDisplay()
        }
    }
    
    @objc private func forwardButtonTapped() {
        guard currentStepIndex < recipe.directions.count - 1 else { return }
        currentStepIndex += 1
        
        // Animate transition
        UIView.transition(with: instructionLabel, duration: 0.3, options: .transitionCrossDissolve) {
            self.updateDisplay()
        }
    }
}
