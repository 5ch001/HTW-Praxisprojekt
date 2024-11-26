using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR;

public class ObjectSpawnerScript : MonoBehaviour
{
    public GameObject[] ingredients;
    private List<GameObject> spawnedObjects = new List<GameObject>();
    private float spawnInterval = 2.5f; //alle 2.5 Sekunden spawnt ein Objekt
    private float spawnTimer = 0f;
    private Vector2 xRange = new Vector2(-0.3f, 0.6f); //based on position of ObjectSpawner
    private Vector2 yRange = new Vector2(1, 2f); //based on position of ObjectSpawner
    private float moveSpeed = -4f;
    private float rotationSpeed = 0.2f;
    private float speedIncrease = -0.08f; //Variabler Wert, je nachdem wie schwer/schnell es sich anfühlt
    private float maxSpeed = -12.0f; //Ebenfalls variabel

    void Update()
    {
        HandleSpawning();
        MoveAndRotateObjects();
        DeleteObjects();
    }

    private void SpawnObject() //called by HandleSpawning()
    {
        int randomIndex = Random.Range(0, ingredients.Length);
        GameObject selectedIngredient = ingredients[randomIndex];

        float randomX = Random.Range(xRange.x, xRange.y);
        float randomY = Random.Range(yRange.x, yRange.y);
        if(selectedIngredient.name == "Asteroid 4") randomY = 1; //makes sure that they spawn on the same height as you
        Vector3 spawnPosition = new Vector3(randomX, randomY, transform.position.z);

        GameObject spawnedObject = Instantiate(selectedIngredient, spawnPosition, Quaternion.identity);
        spawnedObject.transform.rotation = Random.rotation;
        spawnedObjects.Add(spawnedObject);
    }

    private void DeleteObjects()
    {
        for (int i = spawnedObjects.Count - 1; i >= 0; i--)
        {
            if (spawnedObjects[i] != null && spawnedObjects[i].transform.position.z < -50f)
            {
                Destroy(spawnedObjects[i]);
                spawnedObjects.RemoveAt(i);
            }
        }
    }
    private void HandleSpawning()
    {
        //TODO: SpawnTimer soll sich reduzieren nach Zeit.
        spawnTimer += Time.deltaTime;
        if (spawnTimer >= spawnInterval)
        {
            SpawnObject();
            spawnTimer = 0f;
            if (moveSpeed >= maxSpeed) moveSpeed += speedIncrease * Time.deltaTime; //>, da minus
        }
    }
    private void MoveAndRotateObjects()
    {
        foreach (GameObject obj in spawnedObjects)
        {
            //Debug.Log(moveSpeed);
            obj.transform.Translate(Vector3.forward * moveSpeed * Time.deltaTime, Space.World);
            obj.transform.Rotate(Vector3.up, rotationSpeed * 360 * Time.deltaTime);
        }
    }
}
