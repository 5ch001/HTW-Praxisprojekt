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

    /// <summary>
    /// Sets the quantity of the specified ingredient in the collected ingredients dictionary. The dictionary fills up with ingredients as the player collects them in the game. However, I am using this method to reduce the quantity of an ingredient when the player uses it in a recipe.
    /// </summary>
    /// <param name="ingredientName">The name of the ingredient, e.g "Pumpkin 1".</param>
    /// <param name="quantity">The quantity to set for the ingredient.</param>
    public static void SetIngredientCount(string ingredientName, int quantity)
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
