using TMPro;
using UnityEngine;

public class IngredientDisplay : MonoBehaviour
{
    public string ingredientName;
    public TextMeshPro countText;
    public int currentQuantity;

    void Start()
    {
        ingredientName = gameObject.name;
        GameManager.SetIngredientCount("Tomato 1", 1); //for testing purposes
        GameManager.SetIngredientCount("Pumpkin 1", 3); //for testing purposes
        GameManager.SetIngredientCount("Carrot 1", 2); //for testing purposes
        GameManager.SetIngredientCount("Apple 1", 4); //for testing purposes
        GameManager.SetIngredientCount("Banana 1", 5); //for testing purposes
        GameManager.SetIngredientCount("Fish 1", 6); //for testing purposes
        GameManager.SetIngredientCount("Meat 1", 7); //for testing purposes
    }

    void Update()
    {
        UpdateDisplay();
    }

    public void UpdateDisplay()
    {
        currentQuantity = GameManager.GetIngredientCount(ingredientName);
        Debug.Log($"Updating display for {ingredientName}: {currentQuantity}");
        if (currentQuantity >= 0)
        {
            countText.text = currentQuantity.ToString();
        }
    }

}