using UnityEngine;

public class CauldronCooking : MonoBehaviour
{
    public RecipeManager recipeManager; // Referenz zum RecipeManager
    public CauldronTrigger cauldronTrigger; // Referenz zur Trigger-Zone
    public SpriteRenderer dishImage; // Der SpriteRenderer, der das Gericht anzeigt
    public ScoreManager scoreManager; // Referenz zum ScoreManager

    void Start() 
    {
        scoreManager = FindFirstObjectByType<ScoreManager>();
    }
    void Update()
    {
        if (cauldronTrigger.collectedIngredients.Count == 3)
        {
            Cook();
        }
    }

    public void Cook()
    {
        // Überprüfe die Zutaten und finde das passende Gericht
        string cookedDishName = recipeManager.CheckRecipe(cauldronTrigger.collectedIngredients);

        if (cookedDishName != null)
        {
            Debug.Log("Gekocht: " + cookedDishName);

            // Finde das passende Sprite basierend auf dem Namen des Gerichts
            Sprite dishSprite = recipeManager.GetDishSprite(cookedDishName);

            // Gericht anzeigen (Sprite ändern)
            dishImage.sprite = dishSprite;

            recipeManager.IncreaseScoreBasedOnDish(cookedDishName);
        }
        else
        {
            Debug.Log("Kein passendes Rezept gefunden. Zeige Standardgericht.");

            // Standardgericht anzeigen, wenn kein Rezept gefunden wird
            dishImage.sprite = recipeManager.anythingElseSprite;

            recipeManager.IncreaseScoreBasedOnDish(null); // null, da kein passendes Rezept gefunden wurde
        }

        // Zutaten zurücksetzen
        cauldronTrigger.collectedIngredients.Clear();
    }
}