using UnityEngine;

public class Shield : MonoBehaviour
{
    void OnCollisionEnter(Collision collision) {
        Destroy(collision.gameObject);
        GetComponent<ParticleSystem>().Emit(100);
    }
}
