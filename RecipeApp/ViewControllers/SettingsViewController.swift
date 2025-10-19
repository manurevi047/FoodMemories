import UIKit

class SettingsViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let apiKeyTextField = UITextField()
    private let saveButton = UIButton(type: .system)
    private let statusLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadSavedAPIKey()
    }
    
    private func setupUI() {
        title = "Settings"
        view.backgroundColor = .systemBackground
        
        // Setup navigation bar
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneButtonTapped)
        )
        
        // Setup scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Setup API Key section
        let apiKeyLabel = UILabel()
        apiKeyLabel.text = "OpenAI API Key"
        apiKeyLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        apiKeyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        apiKeyTextField.placeholder = "Enter your OpenAI API key"
        apiKeyTextField.borderStyle = .roundedRect
        apiKeyTextField.isSecureTextEntry = true
        apiKeyTextField.font = UIFont.systemFont(ofSize: 16)
        apiKeyTextField.translatesAutoresizingMaskIntoConstraints = false
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Your API key is stored securely on your device and is required to generate recipes using AI."
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        saveButton.setTitle("Save API Key", for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        saveButton.backgroundColor = .systemBlue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 8
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        statusLabel.font = UIFont.systemFont(ofSize: 14)
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        [apiKeyLabel, apiKeyTextField, descriptionLabel, saveButton, statusLabel].forEach {
            contentView.addSubview($0)
        }
        
        // Setup constraints
        NSLayoutConstraint.activate([
            // Scroll view constraints
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content view constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // API Key label
            apiKeyLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            apiKeyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            apiKeyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // API Key text field
            apiKeyTextField.topAnchor.constraint(equalTo: apiKeyLabel.bottomAnchor, constant: 12),
            apiKeyTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            apiKeyTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            apiKeyTextField.heightAnchor.constraint(equalToConstant: 44),
            
            // Description label
            descriptionLabel.topAnchor.constraint(equalTo: apiKeyTextField.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Save button
            saveButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Status label
            statusLabel.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 16),
            statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    @objc private func doneButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func saveButtonTapped() {
        guard let apiKey = apiKeyTextField.text, !apiKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showStatus("Please enter a valid API key", isError: true)
            return
        }
        
        UserDefaults.standard.set(apiKey.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "OpenAI_API_Key")
        showStatus("API key saved successfully!", isError: false)
        
        // Clear the text field after saving
        apiKeyTextField.text = ""
    }
    
    private func loadSavedAPIKey() {
        if let savedAPIKey = UserDefaults.standard.string(forKey: "OpenAI_API_Key"), !savedAPIKey.isEmpty {
            apiKeyTextField.text = "••••••••••••••••" // Show masked version
            showStatus("API key is configured", isError: false)
        } else {
            showStatus("No API key configured", isError: true)
        }
    }
    
    private func showStatus(_ message: String, isError: Bool) {
        statusLabel.text = message
        statusLabel.textColor = isError ? .systemRed : .systemGreen
        
        // Clear status after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.statusLabel.text = ""
        }
    }
}
