import Foundation

struct Recipe: Codable {
    let title: String
    let serves: Int
    let prepTime: String
    let cookTime: String
    let ingredients: [RecipeIngredient]
    let directions: [String]
    
    // Optional fields for saved recipes
    let id: String?
    let createdAt: Date?
    
    init(title: String, serves: Int, prepTime: String, cookTime: String, ingredients: [RecipeIngredient], directions: [String], id: String? = nil, createdAt: Date? = nil) {
        self.title = title
        self.serves = serves
        self.prepTime = prepTime
        self.cookTime = cookTime
        self.ingredients = ingredients
        self.directions = directions
        self.id = id
        self.createdAt = createdAt
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case serves
        case prepTime = "prep_time"
        case cookTime = "cook_time"
        case ingredients
        case directions
        case id
        case createdAt = "created_at"
    }
}

struct RecipeIngredient: Codable {
    let name: String
    let quantity: String
    let unit: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case quantity
        case unit
    }
}
