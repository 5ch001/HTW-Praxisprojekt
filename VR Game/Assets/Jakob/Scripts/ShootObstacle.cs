using System;
using Unity.VisualScripting;
using UnityEngine;

public class ShootObstacle : MonoBehaviour
{
    public GameObject ObstaclePrefab;
    public Transform ShootAt;
    public float ShootSpeed;
    public float SpawnDelay = 1;
    public float SpawnDelayJitter = 0.25f;
    
    private float timer;
    private Unity.Mathematics.Random rand = Unity.Mathematics.Random.CreateFromIndex(0);

    void Start()
    {
        SetRandomTimer();
    }

    void Update()
    {
        timer -= Time.deltaTime;

        if(timer <= 0) {
            SetRandomTimer();
            SpawnObstacle();
        }
    }

    void SetRandomTimer()
    {
        timer = SpawnDelay + rand.NextFloat(-1, 1) * SpawnDelayJitter;
    }

    void SpawnObstacle() {
        GameObject obst = Instantiate(ObstaclePrefab, transform);
        obst.GetComponent<AccelTowards>().Target = ShootAt;

        Vector3 dir = new Vector3(
            rand.NextFloat(),
            rand.NextFloat(),
            0
        );
        obst.GetComponent<Rigidbody>().linearVelocity = dir * ShootSpeed;
    }
}
