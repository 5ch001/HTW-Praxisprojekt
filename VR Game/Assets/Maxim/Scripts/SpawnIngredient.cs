using UnityEngine;

public class SpawnIngredient : MonoBehaviour
{
    public GameObject ingredientPrefab;
    private Vector3 spawnAreaMin;
    private Vector3 spawnAreaMax;

    void Start()
    {
        var bounds = GetComponent<BoxCollider>().bounds;
        spawnAreaMin = bounds.min;
        spawnAreaMax = bounds.max;

        // GameManager.SetIngredientCount("Tomato 1", 10); //for testing purposes
        // GameManager.SetIngredientCount("Pumpkin 1", 10); //for testing purposes
        // GameManager.SetIngredientCount("Carrot 1", 10); //for testing purposes
        // GameManager.SetIngredientCount("Apple 1", 10); //for testing purposes
        // GameManager.SetIngredientCount("Banana 1", 10); //for testing purposes
        // GameManager.SetIngredientCount("Fish 1", 10); //for testing purposes
        // GameManager.SetIngredientCount("Meat 1", 10); //for testing purposes
        // GameManager.SetIngredientCount("Bread 1", 10); //for testing purposes
        // GameManager.SetIngredientCount("Mushroom 1", 10); //for testing purposes
        // GameManager.SetIngredientCount("Pear 1", 10); //for testing purposes
        // GameManager.SetIngredientCount("Pepper 1", 10); //for testing purposes
        // GameManager.SetIngredientCount("Steak 1", 10); //for testing purposes
        int ingredientCount = GameManager.GetIngredientCount(ingredientPrefab.name);

        SpawnIngredients(ingredientCount);
    }

    void SpawnIngredients(int count)
    {
        for (int i = 0; i < count; i++)
        {
            var spawnPosition = new Vector3(
                Random.Range(spawnAreaMin.x, spawnAreaMax.x),
                gameObject.transform.position.y + 0.2f,
                Random.Range(spawnAreaMin.z, spawnAreaMax.z)
            );
            GameObject spawnedIngredient = Instantiate(ingredientPrefab, spawnPosition, ingredientPrefab.transform.rotation);
                spawnedIngredient.name = ingredientPrefab.name.Replace(" (Clone)", "");
                spawnedIngredient.name = ingredientPrefab.name.Replace(" 1", "");
        }
    }
}
