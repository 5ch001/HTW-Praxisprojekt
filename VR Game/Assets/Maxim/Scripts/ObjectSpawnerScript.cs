using System.Collections.Generic;
using UnityEngine;

public class ObjectSpawnerScript : MonoBehaviour
{
    public GameObject[] ingredients;
    private List<GameObject> spawnedObjects = new List<GameObject>();
    private float spawnInterval = 2.5f;
    private float spawnTimer = 0f;
    private Vector2 xRange = new Vector2(-0.3f, 0.6f); //based on position of IngredientSpawner
    private Vector2 yRange = new Vector2(1, 2f); //based on position of IngredientSpawner
    private float moveSpeed = -5f;
    private float rotationSpeed = 0.2f;

    void Update()
    {
        spawnTimer += Time.deltaTime;
        if (spawnTimer >= spawnInterval)
        {
            SpawnObject();
            spawnTimer = 0f;
        }

        for (int i = 0; i < spawnedObjects.Count; i++)
        {
            spawnedObjects[i].transform.Translate(Vector3.forward * moveSpeed * Time.deltaTime, Space.World);
            spawnedObjects[i].transform.Rotate(Vector3.up, rotationSpeed * 360 * Time.deltaTime);

            if (spawnedObjects[i].transform.position.z >= 50f)
            {
                Destroy(spawnedObjects[i]);
                spawnedObjects.RemoveAt(i);
            }
        }
    }

    void SpawnObject()
    {
        int randomIndex = Random.Range(0, ingredients.Length);

        float randomX = Random.Range(xRange.x, xRange.y);
        float randomY = Random.Range(yRange.x, yRange.y);
        Vector3 spawnPosition = new Vector3(randomX, randomY, transform.position.z);

        GameObject spawnedObject = Instantiate(ingredients[randomIndex], spawnPosition, Quaternion.identity);
        spawnedObject.transform.rotation = Random.rotation;
        spawnedObjects.Add(spawnedObject);
    }
}
