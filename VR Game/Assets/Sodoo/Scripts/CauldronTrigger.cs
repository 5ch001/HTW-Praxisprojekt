using UnityEngine;
using System.Collections.Generic;

public class CauldronTrigger : MonoBehaviour
{
    public List<string> collectedIngredients = new List<string>();

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Ingredient"))
        {
            string ingredientName = other.gameObject.name;
            collectedIngredients.Add(ingredientName);
            SoundManager.Instance.PlayCookingSound();
            Debug.Log("Zutat hinzugefügt: " + ingredientName);
            Destroy(other.gameObject);
        }
    }
}
