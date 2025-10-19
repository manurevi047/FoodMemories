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
        
        print("API Key length: \(apiKey.count)")
        print("API Key starts with: \(String(apiKey.prefix(10)))...")
        
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
        
        let cookingStyles = ["Italian", "Asian", "Mexican", "Mediterranean", "Indian", "American", "French", "Thai", "Chinese", "Middle Eastern"]
        let randomStyle = cookingStyles.randomElement() ?? "International"
        
        let prompt = """
        Generate a delicious \(randomStyle) style recipe using these ingredients: \(ingredientsText)
        
        IMPORTANT: Respond ONLY with a valid JSON object in this exact format. Do not include any text before or after the JSON:
        
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
        
        Be creative and create a unique \(randomStyle) style recipe that uses the provided ingredients. Include all necessary additional ingredients for a complete recipe. Make it different from typical recipes. Respond with ONLY the JSON object, no other text.
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
                print("Network error: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            // Check HTTP response status
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 401 {
                    DispatchQueue.main.async {
                        completion(.failure(OpenAIError.unauthorized))
                    }
                    return
                } else if httpResponse.statusCode == 429 {
                    DispatchQueue.main.async {
                        completion(.failure(OpenAIError.rateLimit))
                    }
                    return
                } else if httpResponse.statusCode != 200 {
                    DispatchQueue.main.async {
                        completion(.failure(OpenAIError.invalidResponse))
                    }
                    return
                }
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(OpenAIError.noData))
                }
                return
            }
            
            do {
                // First, let's check if we got a valid response
                if let responseString = String(data: data, encoding: .utf8) {
                    print("OpenAI Response: \(responseString)")
                }
                
                let response = try JSONDecoder().decode(OpenAIResponse.self, from: data)
                if let content = response.choices.first?.message.content {
                    print("OpenAI Content: \(content)")
                    
                    // Try to extract JSON from the response content
                    let jsonStart = content.range(of: "{")
                    let jsonEnd = content.range(of: "}", options: .backwards)
                    
                    // Try to parse the entire content as JSON first
                    if let jsonData = content.data(using: .utf8) {
                        do {
                            let recipe = try JSONDecoder().decode(Recipe.self, from: jsonData)
                            DispatchQueue.main.async {
                                completion(.success(recipe))
                            }
                            return
                        } catch {
                            print("Failed to parse entire content as JSON: \(error)")
                        }
                    }
                    
                    // If that fails, try to extract JSON from the content
                    if let start = jsonStart?.lowerBound, let end = jsonEnd?.upperBound {
                        let jsonString = String(content[start..<end])
                        print("Extracted JSON: \(jsonString)")
                        
                        if let jsonData = jsonString.data(using: .utf8) {
                            do {
                                let recipe = try JSONDecoder().decode(Recipe.self, from: jsonData)
                                DispatchQueue.main.async {
                                    completion(.success(recipe))
                                }
                                return
                            } catch {
                                print("Failed to parse extracted JSON: \(error)")
                            }
                        }
                    }
                    
                    // If all parsing attempts fail, return error
                    DispatchQueue.main.async {
                        completion(.failure(OpenAIError.invalidResponse))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(OpenAIError.invalidResponse))
                    }
                }
            } catch {
                print("JSON Decoding Error: \(error)")
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
    case unauthorized
    case rateLimit
    
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
        case .unauthorized:
            return "API key is invalid or expired. Please check your OpenAI API key in Settings."
        case .rateLimit:
            return "API rate limit exceeded. Please wait a moment and try again."
        }
    }
}
