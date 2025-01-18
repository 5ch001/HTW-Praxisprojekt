using System.Collections.Generic;
using UnityEngine;

public class AsteroidSpawner : MonoBehaviour
{
    public GameObject[] asteroids;
    private float spawnInterval = 25f; //Sekunden
    private float spawnReduction = 1.5f; //Sekunden
    private float maxSpawnInterval = 10f;
    private float spawnTimer;
    private int burstCount = 0;
    private float moveSpeed = -3f;
    private float rotationSpeed = 0.2f;
    private float speedIncrease = -0.03f;
    private float maxSpeed = -15.0f;
    private int burstObjects;
    public float min_x_Range;
    public float max_x_Range;
    private Vector2 xRange;
    private Vector2 yRange = new Vector2(1f, 2f);
    private Vector2 zRange = new Vector2(-40f, -36f);
    private List<GameObject> spawnedAsteroids = new List<GameObject>();
    private bool inBurst = false;
    private float burstInterval = 0.2f;

    void Start()
    {
        xRange = new Vector2(min_x_Range, max_x_Range);
    }

    void Update()
    {
        HandleSpawning();
        MoveAndRotateObjects();
        DestroyOldAsteroids();
    }

    private void HandleSpawning()
    {
        burstObjects = Random.Range(1, 3);
        spawnTimer += Time.deltaTime;
        if (moveSpeed > maxSpeed) moveSpeed += speedIncrease * Time.deltaTime;
        if (!inBurst && spawnTimer >= spawnInterval)
        {
            inBurst = true;
            spawnTimer = 0f;
            burstCount = burstObjects;
            spawnInterval = Mathf.Max(spawnInterval - spawnReduction, maxSpawnInterval); // Decrease spawn interval
        }

        if (inBurst)
        {
            if (spawnTimer >= burstInterval && burstCount > 0)
            {
                SpawnAsteroid();
                spawnTimer = 0f;
                burstCount--;
            }

            if (burstCount <= 0) inBurst = false;
        }
    }

    private void SpawnAsteroid()
    {
        GameObject selectedAsteroid = GetRandomAsteroid();
        float randomX = Random.Range(xRange.x, xRange.y);
        float randomY = Random.Range(yRange.x, yRange.y);
        float randomZ = Random.Range(zRange.x, zRange.y);
        Vector3 spawnPosition = new Vector3(randomX, randomY, randomZ);
        GameObject spawnedAsteroid = Instantiate(selectedAsteroid, spawnPosition, Quaternion.identity);
        spawnedAsteroid.tag = "asteroid";
        spawnedAsteroids.Add(spawnedAsteroid);
    }

    private GameObject GetRandomAsteroid()
    {
        return asteroids[Random.Range(0, asteroids.Length)];
    }

    private void MoveAndRotateObjects()
    {
        for (int i = spawnedAsteroids.Count - 1; i >= 0; i--)
        {
            GameObject asteroid = spawnedAsteroids[i];
            if (asteroid == null)
            {
                spawnedAsteroids.RemoveAt(i);
                continue;
            }
            asteroid.transform.Translate((transform.forward * -1) * moveSpeed * Time.deltaTime, Space.World);
            asteroid.transform.Rotate(Vector3.up, rotationSpeed * 360 * Time.deltaTime);
        }
    }
    private void DestroyOldAsteroids()
    {
        for (int i = spawnedAsteroids.Count - 1; i >= 0; i--)
        {
            if (spawnedAsteroids[i] != null && spawnedAsteroids[i].transform.position.z > 50f)
            {
                Destroy(spawnedAsteroids[i]);
                spawnedAsteroids.RemoveAt(i);
            }
        }
    }
}
