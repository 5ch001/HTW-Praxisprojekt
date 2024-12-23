using UnityEngine;

public class SpawnParticleOnDestroy : MonoBehaviour
{
    [SerializeField] private ParticleSystem particlePrefab;

    void OnDestroy()
    {
        if (particlePrefab != null)
        {
            Instantiate(particlePrefab, transform.position, Quaternion.identity);
        }
    }
}
