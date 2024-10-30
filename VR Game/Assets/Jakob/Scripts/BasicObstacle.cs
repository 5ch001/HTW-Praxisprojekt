using System;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.XR.Interaction.Toolkit.Utilities;

public class BasicObstacle : MonoBehaviour
{
    public float movementSpeed = 1;
    private float lifetime = 0;
    private Vector3 baseScale;

    void Start() {
        baseScale = transform.localScale;
        transform.localScale *= 0;
    }

    void Update()
    {
        lifetime += Time.deltaTime;

        transform.localScale = BurstLerpUtility.BounceOutLerp(0, 1, lifetime) * baseScale;

        transform.position += transform.forward * Time.deltaTime * movementSpeed;
    }
}
