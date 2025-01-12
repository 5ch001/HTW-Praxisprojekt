using System.Collections.Generic; // Make sure to include this for using Lists
using Unity.Collections;
using UnityEngine;

public class GameManager : MonoBehaviour
{
    // This list will hold the names of all collected objects
    public static Dictionary<string, int> collectedIngredients = new Dictionary<string, int>();
    //Being used in DestroyOnGrab.cs

    void Awake()
    {
        DontDestroyOnLoad(this.gameObject);
    }

    public static int GetIngredientCount(string ingredientName)
    {
        if (collectedIngredients.ContainsKey(ingredientName))
        {
            return collectedIngredients[ingredientName];
        }
        return 0;
    }

    public static void SetIngredientCount(string ingredientName, int quantity) //for testing purposes
    {
        if (collectedIngredients.ContainsKey(ingredientName))
        {
            collectedIngredients[ingredientName] = quantity;
        }
        else
        {
            collectedIngredients.Add(ingredientName, quantity);
        }
    }

    public static void ResetCollectedIngredients()
    {
        collectedIngredients.Clear();
    }

    public static void PrintCollectedIngredients()
    {
        foreach (KeyValuePair<string, int> ingredient in collectedIngredients)
        {
            Debug.Log($"Ingredient: {ingredient.Key}, Quantity: {ingredient.Value}");
        }
    }

}
