# Supabase Setup Instructions

## 1. Create a Supabase Project

1. Go to [supabase.com](https://supabase.com)
2. Sign up or log in to your account
3. Click "New Project"
4. Choose your organization and enter project details
5. Set a database password (save this securely)
6. Wait for the project to be created

## 2. Set up the Database Table

1. In your Supabase dashboard, go to the **SQL Editor**
2. Copy and paste the contents of `database_setup.sql` into the editor
3. Click **Run** to execute the SQL script
4. This will create the `recipes` table with the necessary columns

## 3. Get Your API Credentials

1. In your Supabase dashboard, go to **Settings** → **API**
2. Copy your **Project URL** and **anon/public key**
3. You'll need these to configure the app

## 4. Configure the App

1. Open `RecipeApp/Services/SupabaseService.swift`
2. Replace the placeholder values:
   ```swift
   private let supabaseURL = "YOUR_SUPABASE_URL"  // Replace with your Project URL
   private let supabaseAPIKey = "YOUR_SUPABASE_ANON_KEY"  // Replace with your anon key
   ```

## 5. Test the Integration

1. Build and run the app
2. Generate a recipe in the Kitchen tab
3. Click the "Save" button in the recipe popup
4. Check the Cook Book tab to see your saved recipes
5. Verify the recipe appears in your Supabase dashboard under **Table Editor** → **recipes**

## Database Schema

The `recipes` table has the following structure:

| Column | Type | Description |
|--------|------|-------------|
| `id` | UUID | Primary key, auto-generated |
| `title` | TEXT | Recipe title |
| `serves` | INTEGER | Number of servings |
| `prep_time` | TEXT | Preparation time |
| `cook_time` | TEXT | Cooking time |
| `ingredients` | JSONB | Array of ingredient objects |
| `directions` | JSONB | Array of cooking steps |
| `created_at` | TIMESTAMP | When the recipe was saved |

## Security Notes

- The default setup uses Row Level Security (RLS)
- Currently allows all operations for authenticated users
- For production, consider implementing proper user authentication
- The anon key is safe to use in client applications

## Troubleshooting

- **401 Unauthorized**: Check your API key and URL
- **Table doesn't exist**: Make sure you ran the SQL setup script
- **Connection errors**: Verify your Supabase project is active and URL is correct
