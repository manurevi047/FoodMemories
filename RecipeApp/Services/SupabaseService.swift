import Foundation

struct SupabaseService {
    static let shared = SupabaseService()
    
    // TODO: Replace with your actual Supabase URL and API key
    private let supabaseURL = "YOUR_SUPABASE_URL"
    private let supabaseAPIKey = "YOUR_SUPABASE_ANON_KEY"
    
    private init() {}
    
    // MARK: - Recipe Operations
    
    func saveRecipe(_ recipe: Recipe, completion: @escaping (Result<SavedRecipe, Error>) -> Void) {
        guard let url = URL(string: "\(supabaseURL)/rest/v1/recipes") else {
            completion(.failure(SupabaseError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(supabaseAPIKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("prefer", forHTTPHeaderField: "return=representation")
        
        let savedRecipe = SavedRecipe(
            id: nil,
            title: recipe.title,
            serves: recipe.serves,
            prepTime: recipe.prepTime,
            cookTime: recipe.cookTime,
            ingredients: recipe.ingredients,
            directions: recipe.directions,
            createdAt: Date()
        )
        
        do {
            request.httpBody = try JSONEncoder().encode(savedRecipe)
        } catch {
            completion(.failure(SupabaseError.encodingError))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(SupabaseError.noData))
                return
            }
            
            do {
                let savedRecipes = try JSONDecoder().decode([SavedRecipe].self, from: data)
                if let savedRecipe = savedRecipes.first {
                    completion(.success(savedRecipe))
                } else {
                    completion(.failure(SupabaseError.noRecipeReturned))
                }
            } catch {
                completion(.failure(SupabaseError.decodingError))
            }
        }.resume()
    }
    
    func fetchAllRecipes(completion: @escaping (Result<[SavedRecipe], Error>) -> Void) {
        guard let url = URL(string: "\(supabaseURL)/rest/v1/recipes?order=created_at.desc") else {
            completion(.failure(SupabaseError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(supabaseAPIKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(SupabaseError.noData))
                return
            }
            
            do {
                let recipes = try JSONDecoder().decode([SavedRecipe].self, from: data)
                completion(.success(recipes))
            } catch {
                completion(.failure(SupabaseError.decodingError))
            }
        }.resume()
    }
    
    func deleteRecipe(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(supabaseURL)/rest/v1/recipes?id=eq.\(id)") else {
            completion(.failure(SupabaseError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(supabaseAPIKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }.resume()
    }
}

// MARK: - Models

struct SavedRecipe: Codable {
    let id: String?
    let title: String
    let serves: Int
    let prepTime: String
    let cookTime: String
    let ingredients: [RecipeIngredient]
    let directions: [String]
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case serves
        case prepTime = "prep_time"
        case cookTime = "cook_time"
        case ingredients
        case directions
        case createdAt = "created_at"
    }
}

// MARK: - Errors

enum SupabaseError: Error, LocalizedError {
    case invalidURL
    case noData
    case encodingError
    case decodingError
    case noRecipeReturned
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid Supabase URL"
        case .noData:
            return "No data received from server"
        case .encodingError:
            return "Failed to encode recipe data"
        case .decodingError:
            return "Failed to decode server response"
        case .noRecipeReturned:
            return "No recipe returned from server"
        }
    }
}
