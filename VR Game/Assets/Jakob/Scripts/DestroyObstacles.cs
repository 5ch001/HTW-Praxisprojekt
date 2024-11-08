using UnityEngine;

public class DestroyObstacles : MonoBehaviour
{
    void OnTriggerEnter(Collider other) {
        if (other.GetComponent<AccelTowards>()) {
            Destroy(other.gameObject);
        }
    }
}
