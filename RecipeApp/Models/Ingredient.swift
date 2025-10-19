import Foundation

struct Ingredient: Identifiable, Codable {
    let id = UUID()
    var name: String
    var quantity: String
    var unit: String
    var category: IngredientCategory
    
    init(name: String, quantity: String = "", unit: String = "", category: IngredientCategory = .other) {
        self.name = name
        self.quantity = quantity
        self.unit = unit
        self.category = category
    }
}

enum IngredientCategory: String, CaseIterable, Codable {
    case vegetables = "Vegetables"
    case fruits = "Fruits"
    case meat = "Meat"
    case dairy = "Dairy"
    case grains = "Grains"
    case spices = "Spices"
    case other = "Other"
    
    var emoji: String {
        switch self {
        case .vegetables: return "🥕"
        case .fruits: return "🍎"
        case .meat: return "🥩"
        case .dairy: return "🥛"
        case .grains: return "🌾"
        case .spices: return "🌶️"
        case .other: return "📦"
        }
    }
}
