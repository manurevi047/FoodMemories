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
    
    static func emojiForIngredient(_ ingredientName: String) -> String {
        let name = ingredientName.lowercased()
        
        // Vegetables
        if name.contains("tomato") || name.contains("tomatoes") { return "🍅" }
        if name.contains("carrot") || name.contains("carrots") { return "🥕" }
        if name.contains("potato") || name.contains("potatoes") { return "🥔" }
        if name.contains("onion") || name.contains("onions") { return "🧅" }
        if name.contains("garlic") { return "🧄" }
        if name.contains("cucumber") || name.contains("cucumbers") { return "🥒" }
        if name.contains("lettuce") || name.contains("salad") { return "🥬" }
        if name.contains("pepper") || name.contains("bell pepper") { return "🫑" }
        if name.contains("chili") || name.contains("chilli") { return "🌶️" }
        if name.contains("mushroom") || name.contains("mushrooms") { return "🍄" }
        if name.contains("corn") { return "🌽" }
        if name.contains("broccoli") { return "🥦" }
        if name.contains("spinach") { return "🥬" }
        if name.contains("cabbage") { return "🥬" }
        if name.contains("beet") || name.contains("beets") { return "🥕" }
        if name.contains("radish") || name.contains("radishes") { return "🥕" }
        
        // Fruits
        if name.contains("apple") || name.contains("apples") { return "🍎" }
        if name.contains("banana") || name.contains("bananas") { return "🍌" }
        if name.contains("orange") || name.contains("oranges") { return "🍊" }
        if name.contains("lemon") || name.contains("lemons") { return "🍋" }
        if name.contains("lime") || name.contains("limes") { return "🍋" }
        if name.contains("grape") || name.contains("grapes") { return "🍇" }
        if name.contains("strawberry") || name.contains("strawberries") { return "🍓" }
        if name.contains("blueberry") || name.contains("blueberries") { return "🫐" }
        if name.contains("cherry") || name.contains("cherries") { return "🍒" }
        if name.contains("peach") || name.contains("peaches") { return "🍑" }
        if name.contains("pineapple") { return "🍍" }
        if name.contains("watermelon") { return "🍉" }
        if name.contains("melon") || name.contains("cantaloupe") { return "🍈" }
        if name.contains("avocado") || name.contains("avocados") { return "🥑" }
        if name.contains("mango") || name.contains("mangos") { return "🥭" }
        if name.contains("kiwi") || name.contains("kiwis") { return "🥝" }
        
        // Meat & Protein
        if name.contains("chicken") { return "🐔" }
        if name.contains("beef") { return "🥩" }
        if name.contains("pork") { return "🥩" }
        if name.contains("fish") { return "🐟" }
        if name.contains("salmon") { return "🐟" }
        if name.contains("tuna") { return "🐟" }
        if name.contains("shrimp") || name.contains("prawn") { return "🦐" }
        if name.contains("crab") { return "🦀" }
        if name.contains("lobster") { return "🦞" }
        if name.contains("egg") || name.contains("eggs") { return "🥚" }
        if name.contains("tofu") { return "🧈" }
        
        // Dairy
        if name.contains("milk") { return "🥛" }
        if name.contains("cheese") { return "🧀" }
        if name.contains("butter") { return "🧈" }
        if name.contains("yogurt") || name.contains("yoghurt") { return "🥛" }
        if name.contains("cream") { return "🥛" }
        if name.contains("curd") { return "🥛" }
        
        // Grains & Bread
        if name.contains("bread") { return "🍞" }
        if name.contains("rice") { return "🍚" }
        if name.contains("pasta") || name.contains("noodle") { return "🍝" }
        if name.contains("flour") { return "🌾" }
        if name.contains("oats") || name.contains("oatmeal") { return "🌾" }
        if name.contains("quinoa") { return "🌾" }
        if name.contains("barley") { return "🌾" }
        if name.contains("wheat") { return "🌾" }
        
        // Spices & Seasonings
        if name.contains("salt") { return "🧂" }
        if name.contains("pepper") { return "⚫" }
        if name.contains("sugar") { return "🍯" }
        if name.contains("honey") { return "🍯" }
        if name.contains("olive oil") || name.contains("oil") { return "🫒" }
        if name.contains("vinegar") { return "🫗" }
        if name.contains("mustard") { return "🟡" }
        if name.contains("ketchup") || name.contains("sauce") { return "🍅" }
        if name.contains("ginger") { return "🫚" }
        if name.contains("basil") || name.contains("herb") { return "🌿" }
        if name.contains("oregano") { return "🌿" }
        if name.contains("thyme") { return "🌿" }
        if name.contains("rosemary") { return "🌿" }
        if name.contains("parsley") { return "🌿" }
        if name.contains("cilantro") || name.contains("coriander") { return "🌿" }
        if name.contains("curry") { return "🌶️" }
        if name.contains("paprika") { return "🌶️" }
        if name.contains("cinnamon") { return "🌿" }
        if name.contains("nutmeg") { return "🌿" }
        if name.contains("vanilla") { return "🌿" }
        
        // Nuts & Seeds
        if name.contains("almond") || name.contains("almonds") { return "🌰" }
        if name.contains("walnut") || name.contains("walnuts") { return "🌰" }
        if name.contains("peanut") || name.contains("peanuts") { return "🥜" }
        if name.contains("cashew") || name.contains("cashews") { return "🌰" }
        if name.contains("seed") || name.contains("seeds") { return "🌰" }
        
        // Default fallback
        return "📦"
    }
}
