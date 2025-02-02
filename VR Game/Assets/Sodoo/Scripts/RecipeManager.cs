using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[System.Serializable]
public class Recipe
{
    public string name;
    public List<string> ingredients;
}

public class RecipeManager : MonoBehaviour
{
    public List<Recipe> recipes = new List<Recipe>();
    public List<Sprite> dishSprites = new List<Sprite>(); // Liste der Gericht-Sprites
    public Sprite anythingElseSprite; // Der Standard-Sprite, der angezeigt wird, wenn kein passendes Rezept gefunden wird
    public ParticleSystem normalPart;
    public ParticleSystem rarePart;
    public ParticleSystem legendaryPart;

    void Start()
    {
        recipes.Add(new Recipe { name = "Fish Sandwich", ingredients = new List<string> { "Fish", "Bread", "Apple" } }); //Rare
        recipes.Add(new Recipe { name = "Spicy Fish Stew", ingredients = new List<string> { "Fish", "Carrot", "Pepper" } }); //Rare 
        recipes.Add(new Recipe { name = "Golden Veggie Skewers", ingredients = new List<string> { "Carrot", "Pepper", "Mushroom" } }); //Rare
        recipes.Add(new Recipe { name = "Roasted Veggie Casserole", ingredients = new List<string> { "Carrot", "Pumpkin", "Tomato" } }); //Rare
        recipes.Add(new Recipe { name = "Fruit Pie", ingredients = new List<string> { "Bread", "Pear", "Apple" } }); //Rare
        recipes.Add(new Recipe { name = "Spiced Pear Bake", ingredients = new List<string> { "Pear", "Pepper", "Pumpkin" } }); //Rare
        recipes.Add(new Recipe { name = "Tomato Bruschetta", ingredients = new List<string> { "Tomato", "Bread", "Pepper" } }); //Rare
        recipes.Add(new Recipe { name = "Autumn Veggie Soup", ingredients = new List<string> { "Carrot", "Pumpkin", "Mushroom" } }); //Rare
        recipes.Add(new Recipe { name = "Heavenly Fruit Tart", ingredients = new List<string> { "Banana", "Pear", "Apple" } }); //Rare
        recipes.Add(new Recipe { name = "Rustic Meat Pie", ingredients = new List<string> { "Steak", "Bread", "Pumpkin" } }); //Rare
        recipes.Add(new Recipe { name = "Hearty Meat Stew", ingredients = new List<string> { "Tomato", "Steak", "Pepper" } }); //Legendary
        recipes.Add(new Recipe { name = "Surf & Turf Supreme", ingredients = new List<string> { "Tomato", "Fish", "Pepper" } }); //Legendary
        recipes.Add(new Recipe { name = "Meat Stuffed Pumpkin", ingredients = new List<string> { "Steak", "Pumpkin", "Carrot" } }); //Legendary
        recipes.Add(new Recipe { name = "Spiced Mushroom Delight", ingredients = new List<string> { "Mushroom", "Bread", "Pepper" } }); //Legendary
        recipes.Add(new Recipe { name = "Caramelized Pumpkin Tart", ingredients = new List<string> { "Pumpkin", "Bread", "Banana" } }); //Legendary
    }

    public string CheckRecipe(List<string> collectedIngredients)
    {
        foreach (Recipe recipe in recipes)
        {
            if (IsMatch(recipe.ingredients, collectedIngredients))
            {
                return recipe.name; // Rezept gefunden
            }
        }
        return null; // Kein Rezept gefunden
    }

    private bool IsMatch(List<string> recipeIngredients, List<string> collectedIngredients)
    {
        if (collectedIngredients.Count != recipeIngredients.Count)
            return false;

        foreach (string ingredient in recipeIngredients)
        {
            if (!collectedIngredients.Contains(ingredient))
            {
                return false;
            }
        }
        return true;
    }

    public Sprite GetDishSprite(string dishName)
    {
        foreach (Sprite sprite in dishSprites)
        {
            if (sprite.name == dishName)
            {
                return sprite; // Gefundenes Sprite zurückgeben
            }
        }

        // Falls kein Sprite gefunden wird, gebe das Default Sprite zurück (sollte nicht geschehen)
        return anythingElseSprite;
    }

    public void IncreaseScoreBasedOnDish(string dishName)
    {
        int scoreToAdd = 0;

        // Überprüfe, ob das Gericht in der Liste der Rezepte ist
        for (int i = 0; i < recipes.Count; i++)
        {
            if (recipes[i].name == dishName)
            {
                // Letzte 5 Elemente sind Legendary
                if (i >= recipes.Count - 5)
                {
                    scoreToAdd = 50;
                    SoundManager.Instance.PlayLegendarySound();
                    legendaryPart.Play();
                }
                else
                {
                    scoreToAdd = 30;
                    SoundManager.Instance.PlayRareSound();
                    rarePart.Play();

                }
                break;
            }
        }

        // Wenn das Gericht nicht in der Liste ist, füge 10 Punkte hinzu
        if (scoreToAdd == 0)
        {
            scoreToAdd = 10;
             SoundManager.Instance.PlayCookingSound();
             normalPart.Play();
        }
        
        GlobalScore.playerScore += scoreToAdd;
    }
}