# Recipe App

A simple iOS app for recipe generation with ingredient management.

## Features

### Kitchen Tab
- **Create**: Add new ingredients with name, quantity, and unit
- **Read**: View all ingredients in a table with category emojis
- **Update**: Tap on any ingredient to edit its details
- **Delete**: Swipe left on any ingredient to delete it
- **Persistent Storage**: All ingredients are saved locally using UserDefaults

### Cook Book Tab
- Currently empty as requested
- Ready for future recipe management features

## Project Structure

```
RecipeApp/
├── RecipeApp.xcodeproj/          # Xcode project file
└── RecipeApp/
    ├── AppDelegate.swift         # App lifecycle management
    ├── SceneDelegate.swift       # Scene lifecycle and tab setup
    ├── Info.plist               # App configuration
    ├── Models/
    │   └── Ingredient.swift     # Ingredient data model
    ├── ViewControllers/
    │   ├── KitchenViewController.swift    # Kitchen tab with CRUD operations
    │   └── CookBookViewController.swift   # Empty cook book tab
    ├── Base.lproj/
    │   ├── Main.storyboard      # Main storyboard
    │   └── LaunchScreen.storyboard  # Launch screen
    └── Assets.xcassets/         # App icons and colors
```

## Getting Started

1. Open `RecipeApp.xcodeproj` in Xcode
2. Select your target device or simulator
3. Build and run the project (⌘+R)

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.0+

## Usage

### Kitchen Tab
- Tap the "+" button to add a new ingredient
- Enter the ingredient name (required), quantity, and unit (optional)
- Tap on any ingredient in the list to edit it
- Swipe left on any ingredient to delete it
- All data is automatically saved and persists between app launches

The app is ready to run and includes full CRUD functionality for ingredient management in the Kitchen tab, with the Cook Book tab left empty as requested for future development.
