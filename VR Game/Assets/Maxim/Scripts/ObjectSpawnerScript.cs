using System.Collections.Generic;
using UnityEngine;

public class ObjectSpawnerScript : MonoBehaviour
{
    public GameObject[] ingredients;
    public PlayerController playerController;
    private List<GameObject> spawnedObjects = new List<GameObject>();
    private float spawnInterval = 2.5f; //Eventuell auf 2.3 am Anfang setzen. 2.5 ist aber okay
    private float spawnTimer = 0f;
    private Vector2 xRange = new Vector2(-0.3f, 0.6f); //based on position of ObjectSpawner
    private Vector2 yRange = new Vector2(1f, 2f); //based on position of ObjectSpawner
    private Vector2 zRange = new Vector2(-40f, -36f); //based on position of (0, 0, 0) (ObjectSpawner ist bei z = 40)
    private float moveSpeed = -3.0f;
    private float rotationSpeed = 0.2f;
    private float speedIncrease = -0.03f; //Variabler Wert, je nachdem wie schwer/schnell es sich anfühlt
    private float maxSpeed = -15.0f; //Ebenfalls variabel
    private float spawnReductionRate = 0.003f; //Auch variabel
    private float minSpawnInterval = 1.5f; //ditto
    private float burstInterval = 0.2f;
    private int burstObjects;
    private int burstCount = 0;
    private bool inBurst = false;

    void Start()
    {
        playerController = FindFirstObjectByType<PlayerController>();
    }

    void Update()
    {
        HandleSpawning();
        MoveAndRotateObjects();
        DeleteOldObjects();
        Debug.Log(moveSpeed);
    }

    private void SpawnObject() //called by HandleSpawning()
    {
        GameObject selectedIngredient = GetWeightedRandomIngredient();

        float randomX = Random.Range(xRange.x, xRange.y);
        float randomY = Random.Range(yRange.x, yRange.y);
        float randomZ = Random.Range(zRange.x, zRange.y);
        if (selectedIngredient.name == "Asteroid 4") randomY = Random.Range(0, 2) == 0 ? 1.3f : 1.6f; //makes sure that they spawn on the same height or above to duck down
        //1.3 ist Augenhöhe und 1.6 ist etwas über, damit man ducken soll
        //Problem könnte sein, dass diese Werte nicht für jeden geeignet sind, da es abhängig ist von der Größe des Spielers.
        Vector3 spawnPosition = new Vector3(randomX, randomY, randomZ);

        GameObject spawnedObject;
        if (selectedIngredient.name.Contains("HealthPack") && playerController.GetHealthAmount() > 80f)
        {
            return; //Don't spawn health packs if the player's health is already high
        }
        else
        {
            spawnedObject = Instantiate(selectedIngredient, spawnPosition, Quaternion.identity);
        }

        if (spawnedObject.name.Contains("HealthPack"))
        {
            float randomYRotation = Random.Range(0, 360f);
            spawnedObject.transform.Rotate(0f, randomYRotation, 0f);
        }
        else
        {
            spawnedObject.transform.rotation = Random.rotation;
        }

        // Assign the "asteroid" tag if the object is "Asteroid 4"
        if (selectedIngredient.name == "Asteroid 4")
        {
            spawnedObject.tag = "asteroid";
        }

        spawnedObjects.Add(spawnedObject);
    }

    private void DeleteOldObjects()
    {
        for (int i = spawnedObjects.Count - 1; i >= 0; i--)
        {
            if (spawnedObjects[i] != null && spawnedObjects[i].transform.position.z > 50f)
            {
                Destroy(spawnedObjects[i]);
                spawnedObjects.RemoveAt(i);
            }
        }
    }
    private void HandleSpawning()
    {
        burstObjects = Random.Range(3, 5);
        spawnTimer += Time.deltaTime;

        if (spawnInterval > minSpawnInterval) spawnInterval -= spawnReductionRate * Time.deltaTime;
        if (moveSpeed > maxSpeed) moveSpeed += speedIncrease * Time.deltaTime; //> da moveSpeed negativ ist

        if (!inBurst && spawnTimer >= spawnInterval)
        {
            inBurst = true;
            spawnTimer = 0f;
            burstCount = burstObjects;
        }

        if (inBurst)
        {
            if (spawnTimer >= burstInterval && burstCount > 0)
            {
                SpawnObject();
                spawnTimer = 0f;
                burstCount--;
            }

            if (burstCount <= 0) inBurst = false;
        }
    }
    private void MoveAndRotateObjects()
    {
        for (int i = spawnedObjects.Count - 1; i >= 0; i--)
        {
            GameObject obj = spawnedObjects[i];
            if (obj == null)
            {
                spawnedObjects.RemoveAt(i);
                continue;
            }
            obj.transform.Translate((Vector3.forward * -1) * moveSpeed * Time.deltaTime, Space.World);
            obj.transform.Rotate(Vector3.up, rotationSpeed * 360 * Time.deltaTime);
        }
    }

    private GameObject GetWeightedRandomIngredient()
    {
        int asteroidWeight = ingredients.Length; //Damit beim Hinzufügen von mehreren Ingredients die Wahrscheinlichkeit trotzdem fair bleibt
        int otherIngredientWeight = 1;
        float healthPackWeight = 0.2f;

        float totalWeight = 0f;
        foreach (GameObject ingredient in ingredients)
        {
            if (ingredient.name.Contains("Asteroid 4"))
            {
                totalWeight += asteroidWeight;
            }
            else if (ingredient.name.Contains("HealthPack") && playerController.GetHealthAmount() <= 80f)
            {
                totalWeight += healthPackWeight;
            }
            else
            {
                totalWeight += otherIngredientWeight;
            }
        }

        // Get a random value between 0 and totalWeight
        float randomValue = Random.Range(0f, totalWeight);

        // Select the ingredient based on the random value
        float cumulativeWeight = 0f;
        foreach (GameObject ingredient in ingredients)
        {
            if (ingredient.name.Contains("Asteroid 4"))
            {
                cumulativeWeight += asteroidWeight;
            }
            else if (ingredient.name.Contains("HealthPack") && playerController.GetHealthAmount() <= 80f)
            {
                cumulativeWeight += healthPackWeight;
            }
            else
            {
                cumulativeWeight += otherIngredientWeight;
            }

            if (randomValue < cumulativeWeight)
            {
                return ingredient;
            }
        }
        return ingredients[0]; //sollte nie geschehen
    }
}
