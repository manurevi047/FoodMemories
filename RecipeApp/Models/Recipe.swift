import Foundation

struct Recipe: Codable {
    let title: String
    let serves: Int
    let prepTime: String
    let cookTime: String
    let ingredients: [RecipeIngredient]
    let directions: [String]
    
    enum CodingKeys: String, CodingKey {
        case title
        case serves
        case prepTime = "prep_time"
        case cookTime = "cook_time"
        case ingredients
        case directions
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
