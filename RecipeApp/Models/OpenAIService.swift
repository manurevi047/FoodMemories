import Foundation

class OpenAIService {
    static let shared = OpenAIService()
    
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    private var apiKey: String {
        return UserDefaults.standard.string(forKey: "OpenAI_API_Key") ?? ""
    }
    
    private init() {}
    
    func generateRecipe(from ingredients: [Ingredient], completion: @escaping (Result<Recipe, Error>) -> Void) {
        guard !apiKey.isEmpty else {
            completion(.failure(OpenAIError.missingAPIKey))
            return
        }
        
        let ingredientsText = ingredients.map { ingredient in
            var text = ingredient.name
            if !ingredient.quantity.isEmpty {
                text += " (\(ingredient.quantity)"
                if !ingredient.unit.isEmpty {
                    text += " \(ingredient.unit)"
                }
                text += ")"
            }
            return text
        }.joined(separator: ", ")
        
        let prompt = """
        Generate a delicious recipe using these ingredients: \(ingredientsText)
        
        Please respond with a JSON object in this exact format:
        {
            "title": "Recipe Name",
            "serves": 4,
            "prep_time": "15 minutes",
            "cook_time": "30 minutes",
            "ingredients": [
                {
                    "name": "ingredient name",
                    "quantity": "amount",
                    "unit": "unit"
                }
            ],
            "directions": [
                "Step 1 instruction",
                "Step 2 instruction"
            ]
        }
        
        Make sure the recipe is practical and uses the provided ingredients creatively. Include all necessary additional ingredients for a complete recipe.
        """
        
        let requestBody: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                [
                    "role": "user",
                    "content": prompt
                ]
            ],
            "max_tokens": 1500,
            "temperature": 0.7
        ]
        
        guard let url = URL(string: baseURL) else {
            completion(.failure(OpenAIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(OpenAIError.noData))
                }
                return
            }
            
            do {
                let response = try JSONDecoder().decode(OpenAIResponse.self, from: data)
                if let content = response.choices.first?.message.content {
                    // Extract JSON from the response content
                    let jsonStart = content.range(of: "{")
                    let jsonEnd = content.range(of: "}", options: .backwards)
                    
                    if let start = jsonStart?.lowerBound, let end = jsonEnd?.upperBound {
                        let jsonString = String(content[start..<end])
                        let recipe = try JSONDecoder().decode(Recipe.self, from: jsonString.data(using: .utf8)!)
                        DispatchQueue.main.async {
                            completion(.success(recipe))
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(.failure(OpenAIError.invalidResponse))
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(OpenAIError.invalidResponse))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}

struct OpenAIResponse: Codable {
    let choices: [Choice]
    
    struct Choice: Codable {
        let message: Message
        
        struct Message: Codable {
            let content: String
        }
    }
}

enum OpenAIError: Error, LocalizedError {
    case missingAPIKey
    case invalidURL
    case noData
    case invalidResponse
    
    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "OpenAI API key is missing. Please add it in Settings."
        case .invalidURL:
            return "Invalid API URL"
        case .noData:
            return "No data received from API"
        case .invalidResponse:
            return "Invalid response from API"
        }
    }
}
