using System.Collections.Generic;
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

    void Start()
    {
        
        recipes.Add(new Recipe { name = "Pasta", ingredients = new List<string> { "Noodles", "Tomato", "Cheese" } });
        recipes.Add(new Recipe { name = "Omelette", ingredients = new List<string> { "Milk", "Eggs", "Paprika" } });
        recipes.Add(new Recipe { name = "Burger", ingredients = new List<string> { "Tomato", "Steak", "Mushroom" } });
        recipes.Add(new Recipe { name = "Apple", ingredients = new List<string> { "Watermelon", "Pear" } });
        recipes.Add(new Recipe { name = "Bread", ingredients = new List<string> { "Tomato", "Steak", "Mushroom" } });
        recipes.Add(new Recipe { name = "Burger", ingredients = new List<string> { "Tomato", "Steak", "Mushroom" } });
        recipes.Add(new Recipe { name = "Broccoli", ingredients = new List<string> { "Tomato", "Steak", "Mushroom" } });
        
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
                GameObject dish = Instantiate(dishPrefab, transform.position, Quaternion.identity);
                dish.name = recipes[i].name;

                // Gericht-Sprite zuweisen
                SpriteRenderer renderer = dish.GetComponent<SpriteRenderer>();
                if (renderer != null && i < dishSprites.Count)
                {
                    renderer.sprite = dishSprites[i];
                }
                return dish;
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
