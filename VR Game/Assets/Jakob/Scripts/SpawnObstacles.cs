using System;
using UnityEngine;

public class SpawnObstacles : MonoBehaviour
{
    public GameObject[] objectPrefabs;
    public float spawnDelay = 1;
    public float spawnRadius = 2.5f;
    private float spawnTimer = 1;

    void Update()
    {
        spawnTimer -= Time.deltaTime;
        if (spawnTimer <= 0) {
            spawnTimer += spawnDelay;
            spawnRandomPrefab();
        }
    }

    void spawnRandomPrefab() {
        if(objectPrefabs.Length == 0) return;
        GameObject prefab = objectPrefabs[UnityEngine.Random.Range(0, objectPrefabs.Length)];
        GameObject spawnedObj = Instantiate(prefab, transform);
        float angle = UnityEngine.Random.value * Mathf.PI * 2;
        Vector3 offset = new Vector3(
            Mathf.Cos(angle),
            Mathf.Sin(angle),
            0
        ) * spawnRadius;
        spawnedObj.transform.position += offset;
    }
}
