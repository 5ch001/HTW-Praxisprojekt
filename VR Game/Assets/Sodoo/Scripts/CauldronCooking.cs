using UnityEngine;
using System.Collections.Generic;

public class CauldronCooking : MonoBehaviour
{
    public RecipeManager recipeManager; // Referenz zum RecipeManager
    public CauldronTrigger cauldronTrigger; // Referenz zur Trigger-Zone
    public List<GameObject> dishSprites; // Liste der 2D Sprites für verschiedene Gerichte
    public Transform dishSpawnPoint; // Der Punkt, an dem das Gericht erscheint (kann ein leeres GameObject in der Szene sein)
    public GameObject currentDish; // Das aktuell angezeigte 2D-Sprite des Gerichts
    public GameObject defaultDishSprite; // Der Standard-Sprite, das angezeigt wird, wenn kein passendes Rezept gefunden wird

    // Diese Funktion wird ausgelöst, wenn der Spieler den Kochprozess startet

    void Update() 
    {
        if (cauldronTrigger.collectedIngredients.Count == 3) Cook();
    }
    public void Cook()
    {

        // Überprüfe die Zutaten und finde das passende Gericht
        string cookedDishName = CheckRecipe();

        if (cookedDishName != null)
        {
            Debug.Log("Gekocht: " + cookedDishName);

            // Lösche das vorherige Gericht, falls eines vorhanden ist
            if (currentDish != null)
            {
                Destroy(currentDish); // Lösche das alte Gericht
            }

            // Finde das passende Prefab basierend auf dem Namen des Gerichts
            GameObject dishPrefab = GetDishPrefab(cookedDishName);

            // Gericht erzeugen (3D-Objekt instanziieren)
            currentDish = Instantiate(dishPrefab, dishSpawnPoint.position, Quaternion.identity);
            currentDish.name = cookedDishName; // Setze den Namen des Gerichts
        }
        else
        {
            Debug.Log("Kein passendes Rezept gefunden. Zeige Standardgericht.");

            // Standardgericht erzeugen, wenn kein Rezept gefunden wird
            if (currentDish != null)
            {
                Destroy(currentDish); // Lösche das alte Gericht
            }

            // Standardgericht erzeugen
            currentDish = Instantiate(defaultDishSprite, dishSpawnPoint.position, Quaternion.identity);
            currentDish.name = "Default Dish"; // Setze den Namen des Standardgerichts
        }

        // Zutaten zurücksetzen
        cauldronTrigger.collectedIngredients.Clear();
    }

    private string CheckRecipe()
    {
        foreach (Recipe recipe in recipeManager.recipes)
        {
            if (IsMatch(recipe.ingredients))
            {
                return recipe.name; // Rezept gefunden
            }
        }
        return null; // Kein Rezept gefunden
    }

    private bool IsMatch(List<string> recipeIngredients)
    {
        List<string> collected = cauldronTrigger.collectedIngredients;

        if (collected.Count != recipeIngredients.Count)
            return false;

        foreach (string ingredient in recipeIngredients)
        {
            if (!collected.Contains(ingredient))
            {
                return false;
            }
        }
        return true;
    }

    // Gibt das passende Prefab für das Gericht zurück
    private GameObject GetDishPrefab(string dishName)
    {
        // Gehe durch alle Prefabs und finde das, das zum Gericht passt
        foreach (GameObject prefab in dishSprites)
        {
            if (prefab.name == dishName)
            {
                return prefab; // Gefundenes Prefab zurückgeben
            }
        }

        // Falls kein Prefab gefunden wird, gebe das Default Prefab zurück
        return defaultDishSprite;
    }

        

}
