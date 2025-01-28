using System.Collections.Generic;
using UnityEngine.UI;
using UnityEngine;

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
    public GameObject dishPrefab; // Prefab des Gerichts
    public Image dishImage; // Bild des Gerichts
    void Start()
    {
        recipes.Add(new Recipe { name = "Fish Sandwich", ingredients = new List<string> { "Fish", "Bread", "Apple" } });
        recipes.Add(new Recipe { name = "Spicy Fish Stew", ingredients = new List<string> { "Fish", "Carrot", "Pepper" } });
        recipes.Add(new Recipe { name = "Golden Veggie Skewers", ingredients = new List<string> { "Carrot", "Pepper", "Mushroom" } });
        recipes.Add(new Recipe { name = "Roasted Veggie Casserole", ingredients = new List<string> { "Carrot", "Pumpkin", "Tomato" } });
        recipes.Add(new Recipe { name = "Fruit Pie", ingredients = new List<string> { "Bread", "Pear", "Apple" } });
        recipes.Add(new Recipe { name = "Spiced Pear Bake", ingredients = new List<string> { "Pear", "Pepper", "Pumpkin" } });
        recipes.Add(new Recipe { name = "Tomato Bruschetta", ingredients = new List<string> { "Tomato", "Bread", "Pepper" } });
        recipes.Add(new Recipe { name = "Autumn Veggie Soup", ingredients = new List<string> { "Carrot", "Pumpkin", "Mushroom" } });
        recipes.Add(new Recipe { name = "Heavenly Fruit Tart", ingredients = new List<string> { "Banana", "Pear", "Apple" } });
        recipes.Add(new Recipe { name = "Rustic Meat Pie", ingredients = new List<string> { "Steak", "Bread", "Pumpkin" } });
        recipes.Add(new Recipe { name = "Hearty Meat Stew", ingredients = new List<string> { "Tomato", "Steak", "Pepper" } });
        recipes.Add(new Recipe { name = "Surf & Turf Supreme", ingredients = new List<string> { "Tomato", "Fish", "Pepper" } });
        recipes.Add(new Recipe { name = "Meat Stuffed Pumpkin", ingredients = new List<string> { "Steak", "Pumpkin", "Carrot" } });
        recipes.Add(new Recipe { name = "Spiced Mushroom Delight", ingredients = new List<string> { "Mushroom", "Bread", "Pepper" } });
        recipes.Add(new Recipe { name = "Caramelized Pumpkin Tart", ingredients = new List<string> { "Pumpkin", "Bread", "Banana" } });
        // TODO: Stelle sicher, dass dishSprites die passenden Sprites in der gleichen Reihenfolge wie die Rezepte enthält
    }

    public GameObject CookDish(List<string> collectedIngredients)
    {
        // Durchlaufe die Rezepte und suche nach einem passenden
        for (int i = 0; i < recipes.Count; i++)
        {
            if (IsMatch(recipes[i].ingredients, collectedIngredients))
            {
                Debug.Log("Rezept gefunden: " + recipes[i].name);

                // Gericht erzeugen
                dishImage.sprite = dishSprites[i]; // Setze das passende Gericht-Sprite
            }
        }

        Debug.Log("Kein passendes Rezept gefunden.");
        return null; // Kein Rezept gefunden
    }

    private bool IsMatch(List<string> recipeIngredients, List<string> collectedIngredients)
    {
        // Prüfe, ob die Zutaten übereinstimmen
        if (recipeIngredients.Count != collectedIngredients.Count)
            return false;

        foreach (string ingredient in recipeIngredients)
        {
            if (!collectedIngredients.Contains(ingredient))
                return false;
        }
        return true;
    }
}
