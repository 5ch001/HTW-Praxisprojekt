using UnityEngine;

public class DestroyArea : MonoBehaviour
{
    private void OnTriggerEnter(Collider other)
    {
        Destroy(other.gameObject);
    }
}
