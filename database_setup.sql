-- Supabase Database Setup for RecipeApp
-- Run this SQL in your Supabase SQL editor to create the recipes table

-- Create the recipes table
CREATE TABLE IF NOT EXISTS recipes (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL,
    serves INTEGER NOT NULL,
    prep_time TEXT NOT NULL,
    cook_time TEXT NOT NULL,
    ingredients JSONB NOT NULL,
    directions JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create an index on created_at for better performance when fetching recipes
CREATE INDEX IF NOT EXISTS idx_recipes_created_at ON recipes(created_at DESC);

-- Enable Row Level Security (RLS) - optional but recommended for production
ALTER TABLE recipes ENABLE ROW LEVEL SECURITY;

-- Create a policy that allows all operations for authenticated users
-- You can modify this policy based on your authentication requirements
CREATE POLICY "Allow all operations for authenticated users" ON recipes
    FOR ALL USING (auth.role() = 'authenticated');

-- If you want to allow public access (not recommended for production), use:
-- CREATE POLICY "Allow public access" ON recipes FOR ALL USING (true);

-- Example query to test the table:
-- INSERT INTO recipes (title, serves, prep_time, cook_time, ingredients, directions)
-- VALUES (
--     'Test Recipe',
--     4,
--     '15 minutes',
--     '30 minutes',
--     '[{"name": "chicken", "quantity": "1", "unit": "kg"}]',
--     '["Step 1: Cook chicken", "Step 2: Serve hot"]'
-- );
